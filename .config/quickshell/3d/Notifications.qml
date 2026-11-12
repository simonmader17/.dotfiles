// Notifications.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Notifications

// Notification daemon (replaces swaync). Holds the tracked notifications, the
// ones currently shown as popups, the notification center state and the
// persisted "Do not disturb" flag. Drawn by NotificationPopupWindow and
// NotificationCenter, one of each per screen (see Bar.qml).
Singleton {
  id: root

  // Key -> notification for the views. Popups win, so a stack-tag replacement
  // shows before Quickshell has added it to trackedNotifications.
  readonly property var byKey: {
    const map = {};
    for (const n of root.sorted) {
      map[root.keyOf(n)] = n;
    }
    for (const n of root.popups) {
      if (n) {
        map[root.keyOf(n)] = n;
      }
    }
    return map;
  }
  property bool centerOpen: false
  // Name of the screen the center is open on
  property string centerScreen: ""
  readonly property int count: root.list.length
  property alias dnd: stateAdapter.dnd
  // Group key -> true for the groups expanded in the center. Reassigned,
  // never mutated. Reset whenever the center opens.
  property var expandedGroups: ({})
  readonly property var groupList: {
    const out = [];
    for (const n of root.sorted) {
      const g = root.groupOf(n);
      if (!out.includes(g)) {
        out.push(g);
      }
    }
    return out;
  }
  // The center groups notifications by app (see groupOf()). `groupList` is
  // the group keys, ordered by each group's newest notification; plain
  // strings for the same reason as `list`. `groupMembers` maps a group key to
  // its notification keys, newest first.
  readonly property var groupMembers: {
    const map = {};
    for (const n of root.sorted) {
      const g = root.groupOf(n);
      (map[g] = map[g] ?? []).push(root.keyOf(n));
    }
    return map;
  }
  property bool historyLoaded: false
  // Time (ms) the center was last open, persisted. Newer notifications count
  // as unread on the bar.
  property alias lastSeen: stateAdapter.lastSeen
  readonly property var list: root.sorted.map(n => root.keyOf(n))
  // Current time for the relative timestamps, refreshed every 30 s
  property real now: Date.now()
  // Sort position (ms of first arrival) per id. A stack-tag replacement
  // inherits the one it replaces, so it takes the same slot.
  property var order: ({})
  // Keys of `popups`, for the popup view (see `list`)
  readonly property var popupKeys: root.popups.filter(n => !!n).map(n
                                                                    => root.keyOf(
                                                                         n)).filter(
                                     (k, i, a) => a.indexOf(k) === i)
  // Notifications currently shown as popups, newest first
  property var popups: []
  // Notifications restored from the history file after a restart: plain
  // objects with the fields the views read, no actions, `isRestored: true`
  // and a dismiss() that removes them here. Reassigned, never mutated.
  property var restored: []
  property int restoredSerial: 0

  // Keys (see keyOf()) of the center's notifications, newest first. The views
  // use plain key strings as their ScriptModel values and look the
  // notification up in `byKey`: a replacement with the same key then updates
  // its card in place instead of animating out and in. (With freshly built
  // { key, notification } objects, ScriptModel can mis-diff a removal and
  // hand the removed row's delegate to the next notification.) Sorted by first
  // arrival (`orderOf()`), then id. Includes the entries restored from the
  // history file (`restored`). Deduplicated by key, keeping the newest, so a
  // stack-tag replacement never shows next to the one it replaces.
  readonly property var sorted: {
    const live = server.trackedNotifications.values.filter(n => n && n.tracked);
    const all = live.concat(root.restored).sort((a, b) => (root.orderOf(b)
                                                          - root.orderOf(a)) || (
            b.id - a.id));
    const seen = {};
    const out = [];
    for (const n of all) {
      const key = root.keyOf(n);
      if (!seen[key]) {
        seen[key] = true;
        out.push(n);
      }
    }
    return out;
  }
  // Shown time (ms) per notification id: arrival or last replacement.
  // Reassigned, never mutated, so bindings update.
  property var times: ({})
  readonly property int unreadCount: root.centerOpen ? 0 : root.sorted.filter(n
                                                                              => !n.isRestored
                                                                                 && root.timeOf(
                                                                                   n) > root.lastSeen).length

  // Emitted when a notification was replaced in place (replaces_id), so its
  // popup card restarts the expiry timer
  signal updated(var notification)

  function clearAll() {
    // Copy first: dismissing removes entries from the model while iterating
    const all = server.trackedNotifications.values.slice();
    for (const n of all) {
      n.dismiss();
    }
    root.restored = [];
    root.popups = [];
  }

  // "Today", "Yesterday" or the date
  function dayLabel(t) {
    const date = new Date(t);
    const today = new Date(root.now);
    const start = x => new Date(x.getFullYear(), x.getMonth(), x.getDate(
                                  )).getTime();
    const days = Math.round((start(today) - start(date)) / 86400000);
    if (days <= 0) {
      return "Today";
    }
    if (days === 1) {
      return "Yesterday";
    }
    return Qt.formatDate(date, date.getFullYear() === today.getFullYear()
                         ? "ddd d MMM" : "ddd d MMM yyyy");
  }

  function dismissGroup(key) {
    // Copy first: dismissing changes groupMembers while iterating
    const members = (root.groupMembers[key] ?? []).map(k => root.byKey[k]);
    for (const n of members) {
      if (n) {
        n.dismiss();
      }
    }
  }

  function focusedScreenName() {
    return Hyprland.focusedMonitor?.name ?? (Quickshell.screens[0]?.name ?? "");
  }

  // Day label of a group's newest notification
  function groupDay(key) {
    const n = root.byKey[(root.groupMembers[key] ?? [])[0]];
    return n ? root.dayLabel(root.timeOf(n)) : "";
  }

  // Group used by the center: one per app and day, so each group sits under
  // the right day header
  function groupOf(n) {
    return "app:" + (n.appName || n.desktopEntry || "") + "|" + Qt.formatDate(
          new Date(root.timeOf(n)), "yyyy-MM-dd");
  }

  // Replacement via replaces_id: Quickshell updates the existing object in
  // place and doesn't emit `notification` again
  function handleUpdate(n) {
    if (!n || !n.tracked) {
      return;
    }
    root.touch(n);
    root.showPopup(n);
    root.updated(n);
  }

  // Identity used by the views. Stack-tagged notifications share a key per
  // app and tag, so a replacement keeps the same row.
  function keyOf(n) {
    if (n.isRestored) {
      return n.key;
    }
    const tag = root.stackTag(n);
    return tag !== "" ? "tag:" + n.appName + ":" + tag : "id:" + n.id;
  }

  // Records saved by this process are notifications kept over a hot reload
  // (keepOnReload): they only get their times back. Everything else (a
  // restart, or entries that were already restored) is restored.
  function loadHistory(text) {
    if (root.historyLoaded) {
      return;
    }
    root.historyLoaded = true;
    let records = [];
    try {
      records = JSON.parse(text || "[]");
    } catch (e) {
      console.warn("Notifications: ignoring unreadable history:", e);
      return;
    }
    const times = Object.assign({}, root.times);
    const order = Object.assign({}, root.order);
    const restored = [];
    for (const r of records) {
      if (!r.restored && r.pid === Quickshell.processId) {
        times[r.liveId] = times[r.liveId] ?? r.time;
        order[r.liveId] = order[r.liveId] ?? r.order;
        continue;
      }
      const serial = ++root.restoredSerial;
      const entry = {
        isRestored: true,
        id: -serial,
        key: String(r.key ?? "").startsWith("tag:") ? r.key : "saved:" + serial,
        appName: r.appName ?? "",
        appIcon: r.appIcon ?? "",
        desktopEntry: r.desktopEntry ?? "",
        image: r.image ?? "",
        summary: r.summary ?? "",
        body: r.body ?? "",
        urgency: r.urgency ?? NotificationUrgency.Normal,
        savedTime: r.time ?? 0,
        savedOrder: r.order ?? 0,
        actions: [],
        hints: ({}),
        tracked: true,
        transient: false,
        expireTimeout: 0,
        hasInlineReply: false
      };
      entry.dismiss = () => {
        root.restored = root.restored.filter(o => o !== entry);
      };
      restored.push(entry);
    }
    root.times = times;
    root.order = order;
    root.restored = root.restored.concat(restored);
  }

  function orderOf(n) {
    return n.isRestored ? n.savedOrder : (root.order[n.id] ?? 0);
  }

  // Image paths survive a restart, in-memory images (image://) don't
  function persistableImage(image) {
    const s = String(image ?? "");
    return s.startsWith("/") || s.startsWith("file://") ? s : "";
  }

  // "now", "N min ago", then hh:mm (the center's day headers give the day)
  function relativeTime(t) {
    if (!t) {
      return "";
    }
    const d = root.now - t;
    if (d < 60000) {
      return "now";
    }
    if (d < 3600000) {
      return Math.floor(d / 60000) + " min ago";
    }
    return Qt.formatTime(new Date(t), "hh:mm");
  }

  function removePopup(n) {
    root.popups = root.popups.filter(p => p && p !== n);
  }

  function saveHistory() {
    if (!root.historyLoaded) {
      return;
    }
    const records = root.sorted.filter(n => !n.transient).slice(0, 100).map(n => (
    {
      key: root.keyOf(n),
      liveId: n.isRestored ? -1 : n.id,
      pid: Quickshell.processId,
      restored: !!n.isRestored,
      appName: n.appName ?? "",
      appIcon: n.appIcon ?? "",
      desktopEntry: n.desktopEntry ?? "",
      image: root.persistableImage(n.image),
      summary: n.summary ?? "",
      body: n.body ?? "",
      urgency: Number(n.urgency ?? NotificationUrgency.Normal),
      time: root.timeOf(n),
      order: root.orderOf(n)
    }));
    historyFile.setText(JSON.stringify(records));
  }

  // Shows n as a popup (moved to the top), unless the center is open or DND
  // is on. Critical notifications ignore DND.
  function showPopup(n) {
    // Already showing: update in place, don't move it
    if (root.popups.includes(n)) {
      return;
    }
    if (root.centerOpen || (root.dnd && n.urgency
                            !== NotificationUrgency.Critical)) {
      return;
    }
    root.popups = [n].concat(root.popups.filter(p => p && p !== n));
  }

  // Stack tag hints (dunst / swaync style), used to replace notifications
  // that don't use replaces_id, e.g. volume OSD scripts
  function stackTag(n) {
    const h = n.hints ?? {};
    return h["x-dunst-stack-tag"] || h["x-canonical-private-synchronous"]
        || h["synchronous"] || "";
  }

  // Shown time (ms) of a live or restored notification
  function timeOf(n) {
    if (!n) {
      return 0;
    }
    return n.isRestored ? n.savedTime : (root.times[n.id] ?? 0);
  }

  function toggleCenter(screenName) {
    if (root.centerOpen && root.centerScreen === screenName) {
      root.centerOpen = false;
      return;
    }
    root.centerScreen = screenName;
    root.centerOpen = true;
    // Everything is visible in the center now
    root.popups = [];
  }

  function toggleDnd() {
    root.dnd = !root.dnd;
  }

  function toggleGroup(key) {
    root.expandedGroups = Object.assign({}, root.expandedGroups, {
                                          [key]: !root.expandedGroups[key]
                                        });
  }

  function touch(n) {
    root.times = Object.assign({}, root.times, {
                                 [n.id]: Date.now()
                               });
  }

  // Collapse all groups when the center opens (not when it closes, so the
  // slide-out doesn't jump)
  onCenterOpenChanged: {
    if (root.centerOpen) {
      root.expandedGroups = {};
      root.now = Date.now();
    }
    // Everything that arrived until the center closes has been seen
    root.lastSeen = Date.now();
  }
  onSortedChanged: saveTimer.restart()
  onTimesChanged: saveTimer.restart()

  Timer {
    interval: 30000
    repeat: true
    running: true

    onTriggered: root.now = Date.now()
  }

  // Debounced save of the history file
  Timer {
    id: saveTimer

    interval: 1000

    onTriggered: root.saveHistory()
  }

  // Notification history, restored after a restart (see loadHistory())
  FileView {
    id: historyFile

    path: Quickshell.statePath("notification-history.json")

    onLoadFailed: error => {
      root.historyLoaded = true;
      if (error !== FileViewError.FileNotFound) {
        console.warn("Notifications: could not read history:", error);
      }
    }
    onLoaded: root.loadHistory(text())
  }

  NotificationServer {
    id: server

    actionsSupported: true
    bodyHyperlinksSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    inlineReplySupported: true
    keepOnReload: true
    persistenceSupported: true

    onNotification: n => {
      n.tracked = true;
      n.closed.connect(() => root.removePopup(n));

      // Replace an older notification with the same stack tag from the same
      // app: take over its slot and its popup, then dismiss it. The dismiss
      // is deferred until Quickshell has added n to trackedNotifications, so
      // the views see a single in-place update (see `list`).
      let replacedPopup = false;
      const key = root.keyOf(n);
      if (key.startsWith("tag:") && root.restored.some(r => r.key === key)) {
        root.restored = root.restored.filter(r => r.key !== key);
      }
      const old = key.startsWith("tag:")
            ? server.trackedNotifications.values.filter(o => o !== n
                                                             && root.keyOf(o)
                                                             === key) : [];
      if (old.length > 0) {
        root.order = Object.assign({}, root.order, {
                                     [n.id]: root.order[old[0].id] ?? Date.now()
                                   });
        if (root.popups.some(p => old.includes(p))) {
          root.popups = root.popups.map(p => old.includes(p) ? n : p).filter((p,
                                                                              i, a) => a.indexOf(
                                                                                         p) === i);
          replacedPopup = true;
        }
        Qt.callLater(() => {
          for (const o of old) {
            if (o) {
              o.dismiss();
            }
          }
        });
      } else {
        root.order = Object.assign({}, root.order, {
                                     [n.id]: Date.now()
                                   });
      }
      root.touch(n);

      // One closure per notification: Qt.callLater merges calls per function,
      // which also merges the signals of one update into a single call
      const onUpdate = () => root.handleUpdate(n);
      const schedule = () => Qt.callLater(onUpdate);
      n.summaryChanged.connect(schedule);
      n.bodyChanged.connect(schedule);
      n.appIconChanged.connect(schedule);
      n.imageChanged.connect(schedule);
      n.actionsChanged.connect(schedule);
      n.urgencyChanged.connect(schedule);
      n.expireTimeoutChanged.connect(schedule);
      n.hintsChanged.connect(schedule);

      if (!replacedPopup) {
        root.showPopup(n);
      }
    }
  }

  // Persists "Do not disturb" and lastSeen across restarts
  FileView {
    path: Quickshell.statePath("notifications.json")

    onAdapterUpdated: writeAdapter()
    onLoadFailed: error => {
      if (error === FileViewError.FileNotFound) {
        writeAdapter();
      }
    }

    JsonAdapter {
      id: stateAdapter

      property bool dnd: false
      property real lastSeen: 0
    }
  }

  // qs -c 3d ipc call notifications toggle|toggleDnd|clear
  IpcHandler {
    function clear(): void {
      root.clearAll();
    }

    function toggle(): void {
      root.toggleCenter(root.focusedScreenName());
    }

    function toggleDnd(): void {
      root.toggleDnd();
    }

    target: "notifications"
  }
}
