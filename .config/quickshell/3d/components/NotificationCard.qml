// components/NotificationCard.qml
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../helper.js" as Helper

import ".."

// One notification as a 3D card: icon, app name and time, summary, body,
// action buttons and a close button. Used for the popups (`popup: true`,
// expires after a timeout) and in the notification center.
My3dButton {
  id: root

  // Icon of the sending app, from appIcon or the desktop entry
  readonly property string appIconSource: {
    const n = root.notification;
    const icon = n?.appIcon ?? "";
    if (icon) {
      if (icon.startsWith("/")) {
        return "file://" + icon;
      }
      if (icon.includes("://")) {
        return icon;
      }
      return Quickshell.iconPath(icon, true);
    }
    if (n?.desktopEntry) {
      return Quickshell.iconPath(Globals.guessIcon(n.desktopEntry), true);
    }
    return "";
  }
  readonly property real arrival: Notifications.timeOf(root.notification)
  // Long bodies are cut off until "Show more"
  property bool bodyExpanded: false
  readonly property var buttonActions: (root.notification?.actions ?? []).filter(
                                         a => a.identifier !== "default"
                                              && a.identifier
                                              !== "inline-reply")
  // In a collapsed group, a click expands the group instead of running the
  // default action
  property bool clickExpands: false
  property real contentWidth: 360
  readonly property var defaultAction: (root.notification?.actions ?? []).find(
                                         a => a.identifier === "default")
                                       ?? null
  property bool dismissing: false
  readonly property bool hasReply: !!root.notification?.hasInlineReply
  // Small icon: the notification image, unless that is a large attachment
  // (shown as a preview instead), else the app icon
  readonly property string iconSource: {
    const image = root.notification?.image ?? "";
    return image && !root.isAttachment ? image : root.appIconSource;
  }
  // A large image (screenshot etc.) rather than an avatar or icon
  readonly property bool isAttachment: preview.status === Image.Ready && (
                                         preview.implicitWidth >= 400
                                         || preview.implicitHeight >= 300)
  required property var notification
  property bool popup: false
  // "value" hint (0-100), e.g. from volume/brightness scripts, -1 if absent
  readonly property int progress: {
    const v = root.notification?.hints?.value;
    return v === undefined || v === null || isNaN(v) ? -1 : Math.max(0, Math.min(
                                                                       100, Math.round(
                                                                         v)));
  }
  // In a collapsed group, swiping the top card away dismisses the whole group
  property bool swipeDismissesGroup: false

  // Swipe to dismiss (mouse drag or touchpad), drawn as a translation so it
  // doesn't fight the ListView transitions on x
  property real swipeX: 0
  readonly property bool swiping: dragHandler.active || gestureEnd.running
  // Monochrome theme icons (e.g. "display-brightness-medium-symbolic") are
  // drawn in a fixed dark grey, so they get recoloured like the card's text.
  // Checked on the shown source: notify-send -i sends the icon as the
  // image-path hint, so it can arrive in `image` as well as `appIcon`.
  readonly property bool symbolicIcon: /-symbolic(\.\w+)?([?#].*)?$/i.test(
                                         root.iconSource)
  readonly property real threshold: width * 0.35
  readonly property int urgency: root.notification?.urgency
                                 ?? NotificationUrgency.Normal

  signal expandRequested
  signal groupDismissRequested

  function fling(sign) {
    root.dismissing = true;
    flingAnimation.to = sign * (root.width + 40);
    flingAnimation.start();
  }

  function sendReply() {
    const text = replyInput.text.trim();
    if (text === "" || !root.notification?.hasInlineReply) {
      return;
    }
    root.notification.sendInlineReply(text);
    replyInput.text = "";
  }

  // Release: fly out past the threshold or on a fast flick, else snap back
  function swipeEnd(velocity) {
    if (root.dismissing) {
      return;
    }
    if (Math.abs(root.swipeX) > root.threshold || Math.abs(velocity) > 1000) {
      root.fling(root.swipeX !== 0 ? Math.sign(root.swipeX) : Math.sign(
                                       velocity));
    } else {
      root.swipeX = 0;
    }
  }

  acceptedButtons: Qt.LeftButton | Qt.MiddleButton
  baseColor: {
    if (root.urgency === NotificationUrgency.Critical) {
      return Pywal.color1;
    }
    if (root.urgency === NotificationUrgency.Low) {
      return Qt.darker(Pywal.color4, 1.3);
    }
    return Pywal.color4;
  }
  opacity: 1 - Math.min(1, Math.abs(root.swipeX) / Math.max(1, root.width))
           * 0.8
  paddingX: 12
  paddingY: 10

  // On the card itself, not in the default `content` (My3dButton puts
  // declared children into the face's content row, above the button's
  // MouseArea), so they cover the whole card and don't swallow clicks on
  // the content
  data: [
    HoverHandler {
      id: hoverHandler
    },

    // Mouse: drag sideways. Once past the drag threshold this takes the grab
    // from the button's MouseArea, so a swipe never counts as a click.
    DragHandler {
      id: dragHandler

      acceptedButtons: Qt.LeftButton
      enabled: !root.dismissing
      target: null
      xAxis.enabled: true
      yAxis.enabled: false

      onActiveChanged: {
        if (!active) {
          root.swipeEnd(centroid.velocity.x);
        }
      }
      onTranslationChanged: root.swipeX = translation.x
    },

    // Touchpad: two-finger horizontal swipe. Not blocking, so vertical
    // scrolling still reaches the notification center's list.
    WheelHandler {
      acceptedDevices: PointerDevice.TouchPad
      blocking: false
      enabled: !root.dismissing
      orientation: Qt.Horizontal
      target: null

      onWheel: event => {
        const dx = event.pixelDelta.x !== 0 ? event.pixelDelta.x :
                                              event.angleDelta.x / 2;
        if (dx === 0 || Math.abs(event.angleDelta.x) < Math.abs(
              event.angleDelta.y)) {
          return;
        }
        // Follow the fingers: Qt reports the scroll direction, which natural
        // scrolling already inverts
        root.swipeX += event.inverted ? dx : -dx;
        if (event.phase === Qt.ScrollEnd) {
          gestureEnd.stop();
          root.swipeEnd(0);
        } else {
          gestureEnd.restart();
        }
      }
    }
  ]

  // Follow the pointer 1:1 while swiping, animate the snap back
  Behavior on swipeX {
    id: swipeBehavior

    enabled: !root.swiping && !root.dismissing

    NumberAnimation {
      duration: 180
      easing.type: Easing.OutCubic
    }
  }
  transform: Translate {
    x: root.swipeX
  }

  onClicked: {
    if (root.clickExpands) {
      root.expandRequested();
      return;
    }
    if (root.defaultAction) {
      root.defaultAction.invoke();
    }
    if (root.popup) {
      Notifications.removePopup(root.notification);
    }
  }
  onMiddleClicked: root.notification?.dismiss()

  // Replaced in place (stack tag: same delegate, new notification; or
  // replaces_id: same notification, new content): show the new content for
  // the full timeout again
  onNotificationChanged: {
    expiry.restarting = true;
    expiry.restarting = false;
    // A card that gets a new notification starts unswiped. Not when it
    // becomes null: that's the dismissed card sliding out.
    if (root.notification) {
      root.bodyExpanded = false;
      flingAnimation.stop();
      root.dismissing = false;
      swipeBehavior.enabled = false;
      root.swipeX = 0;
      swipeBehavior.enabled = Qt.binding(() => !root.swiping &&
                                               !root.dismissing);
    }
  }

  NumberAnimation {
    id: flingAnimation

    duration: 160
    easing.type: Easing.InCubic
    property: "swipeX"
    target: root

    onFinished: {
      if (root.swipeDismissesGroup) {
        root.groupDismissRequested();
      } else {
        root.notification?.dismiss();
      }
    }
  }

  // Touchpad gestures don't always end with a ScrollEnd phase
  Timer {
    id: gestureEnd

    interval: 150

    onTriggered: root.swipeEnd(0)
  }

  // Popup expiry, paused while hovered. Critical notifications stay.
  Timer {
    id: expiry

    // Briefly false to restart without breaking this binding (restart() would)
    property bool restarting: false

    interval: (root.notification?.expireTimeout ?? 0) > 0
              ? root.notification.expireTimeout * 1000 : 5000
    running: root.popup && !restarting && !root.swiping && !root.dismissing &&
             !hoverHandler.hovered && root.urgency
             !== NotificationUrgency.Critical

    onTriggered: Notifications.removePopup(root.notification)
  }

  Connections {
    function onUpdated(n) {
      if (root.popup && n === root.notification) {
        expiry.restarting = true;
        expiry.restarting = false;
      }
    }

    target: Notifications
  }

  RowLayout {
    Layout.preferredWidth: root.contentWidth
    spacing: 10

    // App icon or notification image
    Image {
      Layout.alignment: Qt.AlignTop
      Layout.preferredHeight: 48
      Layout.preferredWidth: 48
      asynchronous: true
      fillMode: Image.PreserveAspectFit

      // Same recolouring as the tray icons (widgets/TrayWidget.qml)
      layer.enabled: root.symbolicIcon
      source: root.iconSource
      sourceSize.height: 96
      sourceSize.width: 96
      visible: root.iconSource !== "" && status !== Image.Error

      layer.effect: MultiEffect {
        brightness: 0.5
        colorization: 1
        colorizationColor: Helper.contrastColor(root.baseColor, Pywal.background,
                                                Pywal.foreground)
        contrast: -1
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2

      // App name and time
      RowLayout {
        Layout.fillWidth: true

        Text {
          Layout.fillWidth: true
          elide: Text.ElideRight
          font.bold: true
          font.family: Globals.myFont.family
          font.pixelSize: 12
          opacity: 0.7
          text: root.notification?.appName || "Notification"
        }

        Text {
          font.bold: true
          font.family: Globals.myFont.family
          font.pixelSize: 12
          opacity: 0.7
          text: Notifications.relativeTime(root.arrival)
          visible: root.arrival > 0
        }

        // Close
        Text {
          font: Globals.myIconFont
          renderType: Globals.myIconFontRenderType
          text: "" // close

          MouseArea {
            anchors.fill: parent
            anchors.margins: -4
            cursorShape: Qt.PointingHandCursor

            onClicked: root.notification?.dismiss()
          }
        }
      }

      Text {
        Layout.fillWidth: true
        elide: Text.ElideRight
        font: Globals.myFont
        maximumLineCount: 2
        text: root.notification?.summary ?? ""
        visible: text !== ""
        wrapMode: Text.Wrap
      }

      Text {
        id: bodyText

        Layout.fillWidth: true
        elide: Text.ElideRight
        font.family: Globals.myFont.family
        font.pixelSize: 13
        maximumLineCount: root.bodyExpanded ? 1000 : (root.popup ? 4 : 12)
        text: root.notification?.body ?? ""
        textFormat: Text.StyledText
        visible: text !== ""
        wrapMode: Text.Wrap

        onLinkActivated: link => Qt.openUrlExternally(link)
      }

      // Show more / less, for bodies cut off at maximumLineCount
      Text {
        font.bold: true
        font.family: Globals.myFont.family
        font.pixelSize: 12
        opacity: 0.8
        text: root.bodyExpanded ? "Show less" : "Show more"
        visible: bodyText.truncated || root.bodyExpanded

        MouseArea {
          anchors.fill: parent
          anchors.margins: -4
          cursorShape: Qt.PointingHandCursor

          onClicked: root.bodyExpanded = !root.bodyExpanded
        }
      }

      // Large image attachment. Loaded for every image to measure it, shown
      // only when it is big enough (isAttachment).
      Image {
        id: preview

        Layout.fillWidth: true
        Layout.preferredHeight: implicitWidth > 0 ? Math.min(root.popup ? 160 :
                                                                          240, width
                                                             * implicitHeight
                                                             / implicitWidth) :
                                                    0
        Layout.topMargin: 4
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignLeft
        source: root.notification?.image ?? ""
        sourceSize.width: 800
        visible: root.isAttachment
      }

      // Progress ("value" hint)
      RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 4
        spacing: 8
        visible: root.progress >= 0

        Rectangle {
          Layout.fillWidth: true
          color: Qt.lighter(root.baseColor, 1.8)
          implicitHeight: 6
          radius: 3

          Rectangle {
            color: Helper.contrastColor(root.baseColor, Pywal.background,
                                        Pywal.foreground)
            height: parent.height
            radius: parent.radius
            width: parent.width * Math.max(0, root.progress) / 100

            Behavior on width {
              NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
              }
            }
          }
        }

        Text {
          Layout.preferredWidth: 40
          font.bold: true
          font.family: Globals.myFont.family
          font.pixelSize: 12
          horizontalAlignment: Text.AlignRight
          text: root.progress + "%"
        }
      }

      // Inline reply, in the center only (popups get no keyboard focus)
      RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 6
        spacing: 6
        visible: root.hasReply && !root.popup

        Rectangle {
          Layout.fillWidth: true
          color: Qt.lighter(root.baseColor, 1.4)
          implicitHeight: replyInput.implicitHeight + 12
          radius: 5

          TextInput {
            id: replyInput

            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            font: Globals.myFont

            onAccepted: root.sendReply()
          }

          Text {
            anchors.left: replyInput.left
            anchors.verticalCenter: parent.verticalCenter
            font: Globals.myFont
            opacity: 0.6
            text: root.notification?.inlineReplyPlaceholder || "Reply…"
            visible: replyInput.text === "" && !replyInput.activeFocus
          }
        }

        // Send
        Text {
          font: Globals.myIconFont
          opacity: replyInput.text.trim() !== "" ? 1 : 0.5
          renderType: Globals.myIconFontRenderType
          text: "\ue163" // send

          MouseArea {
            anchors.fill: parent
            anchors.margins: -4
            cursorShape: Qt.PointingHandCursor

            onClicked: root.sendReply()
          }
        }
      }

      // Actions
      Flow {
        Layout.fillWidth: true
        Layout.topMargin: 6
        spacing: 6
        visible: root.buttonActions.length > 0 || (root.popup && root.hasReply)

        // Popups can't take keyboard focus: reply in the center
        My3dButton {
          baseColor: Qt.lighter(root.baseColor, 1.4)
          paddingY: 4
          visible: root.popup && root.hasReply

          onClicked: {
            Notifications.removePopup(root.notification);
            if (!Notifications.centerOpen) {
              Notifications.toggleCenter(Notifications.focusedScreenName());
            }
          }

          Text {
            font: Globals.myFont
            text: "Reply"
          }
        }

        Repeater {
          model: root.buttonActions

          My3dButton {
            id: actionButton

            required property var modelData

            baseColor: Qt.lighter(root.baseColor, 1.4)
            paddingY: 4

            onClicked: modelData.invoke()

            Text {
              font: Globals.myFont
              text: actionButton.modelData.text
            }
          }
        }
      }
    }
  }
}
