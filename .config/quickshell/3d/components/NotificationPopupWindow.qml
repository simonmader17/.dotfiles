// components/NotificationPopupWindow.qml
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import ".."

// Popups in the top right corner, below the bar. Only shown on the focused
// monitor. The window spans the full height (a ListView only creates the
// delegates that fit, so it can't size the window itself) and is
// click-through except for the cards.
PanelWindow {
  id: root

  // Passed in instead of reading `screen`, which would loop with `visible`
  required property string screenName
  readonly property bool focused: Hyprland.focusedMonitor?.name === root.screenName
  readonly property bool hasPopups: Notifications.popups.length > 0

  // Keep mapped briefly so the last card can slide out
  onHasPopupsChanged: {
    if (!hasPopups) {
      hideDelay.restart();
    }
  }

  visible: root.focused && (root.hasPopups || hideDelay.running)
  color: "transparent"
  exclusionMode: ExclusionMode.Normal
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell-notifications"
  anchors {
    top: true
    right: true
    bottom: true
  }
  margins {
    top: 4
    bottom: 4
    right: 4
  }
  implicitWidth: 384 + 16
  mask: Region {
    item: list.contentItem
  }

  Timer {
    id: hideDelay

    interval: 250
  }

  ListView {
    id: list

    x: 8
    width: parent.width - 8
    height: parent.height
    interactive: false
    spacing: 6
    model: ScriptModel {
      values: Notifications.popupKeys
    }

    // The wrapper takes the view transitions, so they never touch the card's
    // own swipe translation and opacity
    delegate: Item {
      id: slot

      required property string modelData

      width: card.width
      height: card.height

      NotificationCard {
        id: card

        notification: Notifications.byKey[slot.modelData] ?? null
        popup: true
      }
    }

    add: Transition {
      NumberAnimation {
        property: "x"
        from: list.width
        to: 0
        duration: 220
        easing.type: Easing.OutBack
      }
    }
    remove: Transition {
      NumberAnimation {
        property: "x"
        to: list.width
        duration: 180
        easing.type: Easing.InCubic
      }
    }
    displaced: Transition {
      NumberAnimation {
        property: "y"
        duration: 180
        easing.type: Easing.OutCubic
      }
    }
  }
}
