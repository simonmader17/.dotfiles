// components/NotificationCenter.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import ".."

// Panel on the right edge, below the bar, with all notifications, a
// "Do not disturb" toggle and "Clear all". Toggled by NotificationsWidget.
// Clicking outside or pressing Escape closes it.
PanelWindow {
  id: root

  required property PanelWindow bar
  // Passed in instead of reading `screen`, which would loop with `visible`
  required property string screenName
  readonly property bool shown: Notifications.centerOpen
                                && Notifications.centerScreen
                                === root.screenName

  WlrLayershell.keyboardFocus: root.shown ? WlrKeyboardFocus.OnDemand :
                                            WlrKeyboardFocus.None
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell-notification-center"
  color: "transparent"
  exclusionMode: ExclusionMode.Normal
  implicitWidth: 420

  // Stay mapped while the panel slides out
  visible: root.shown || panel.x < root.implicitWidth

  anchors {
    bottom: true
    right: true
    top: true
  }

  HyprlandFocusGrab {
    active: root.shown
    // Include the bar so the bell button can close the center itself
    windows: [root, root.bar]

    onCleared: Notifications.centerOpen = false
  }

  Item {
    id: panel

    focus: true
    height: parent.height
    width: root.implicitWidth

    // implicitWidth, not the window's width, which depends on `visible`
    x: root.shown ? 0 : root.implicitWidth

    Behavior on x {
      NumberAnimation {
        duration: 220
        easing.type: root.shown ? Easing.OutCubic : Easing.InCubic
      }
    }

    Keys.onEscapePressed: Notifications.centerOpen = false

    // Background, like the bar's, with the depth edge on the left
    Rectangle {
      anchors.fill: parent
      color: Pywal.background
      opacity: 0.8

      Rectangle {
        color: Qt.darker(parent.color, 1.2)
        height: parent.height
        opacity: 0.8
        width: 8
      }
    }

    ColumnLayout {
      anchors.bottomMargin: 8
      anchors.fill: parent
      anchors.leftMargin: 16
      anchors.rightMargin: 8
      anchors.topMargin: 8
      spacing: 8

      // Header
      RowLayout {
        Layout.fillWidth: true
        spacing: 6

        Text {
          Layout.fillWidth: true
          color: Pywal.foreground
          elide: Text.ElideRight
          font.bold: true
          font.family: Globals.myFont.family
          font.pixelSize: 18
          text: "Notifications" + (Notifications.count > 0 ? " ("
                                                             + Notifications.count
                                                             + ")" : "")
        }

        // Do not disturb, latched while on
        My3dButton {
          baseColor: Notifications.dnd ? Pywal.color1 : Pywal.color4
          forcePressed: Notifications.dnd

          onClicked: Notifications.toggleDnd()

          RowLayout {
            Text {
              font: Globals.myIconFont
              renderType: Globals.myIconFontRenderType
              text: Notifications.dnd ? "" :
                                        "" // notifications_off / notifications
            }

            Text {
              font: Globals.myFont
              text: "DND"
            }
          }
        }

        // Clear all
        My3dButton {
          baseColor: Pywal.color4
          enabled: Notifications.count > 0
          // Flat while disabled
          forcePressed: !enabled
          opacity: enabled ? 1 : 0.5

          onClicked: Notifications.clearAll()

          RowLayout {
            Text {
              font: Globals.myIconFont
              renderType: Globals.myIconFontRenderType
              text: "" // clear_all
            }

            Text {
              font: Globals.myFont
              text: "Clear"
            }
          }
        }
      }

      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        ListView {
          id: list

          anchors.fill: parent
          boundsBehavior: Flickable.StopAtBounds
          clip: true
          spacing: 6

          add: Transition {
            NumberAnimation {
              duration: 180
              from: 0
              property: "opacity"
              to: 1
            }
          }

          // One group per app. The wrapper takes the view transitions, so
          // whole groups fade in, slide out and shift.
          delegate: Item {
            id: slot

            required property int index
            required property string modelData

            height: group.height
            width: list.width

            NotificationGroup {
              id: group

              // On the first group of each day
              dayHeader: {
                const day = Notifications.groupDay(slot.modelData);
                const prev = slot.index > 0 ? Notifications.groupDay(
                                                Notifications.groupList[slot.index
                                                                        - 1]) : "";
                return day !== prev ? day : "";
              }
              groupKey: slot.modelData
              width: parent.width
            }
          }
          displaced: Transition {
            NumberAnimation {
              duration: 180
              easing.type: Easing.OutCubic
              property: "y"
            }
          }
          model: ScriptModel {
            values: Notifications.groupList
          }
          remove: Transition {
            NumberAnimation {
              duration: 180
              easing.type: Easing.InCubic
              property: "x"
              to: list.width
            }
          }
        }

        // Empty state
        ColumnLayout {
          anchors.centerIn: parent
          opacity: 0.5
          spacing: 4
          visible: list.count === 0

          Text {
            Layout.alignment: Qt.AlignHCenter
            color: Pywal.foreground
            font: Globals.myIconFontOutlined
            renderType: Globals.myIconFontRenderType
            text: Notifications.dnd ? "" :
                                      "" // notifications_off / notifications
          }

          Text {
            Layout.alignment: Qt.AlignHCenter
            color: Pywal.foreground
            font: Globals.myFont
            text: "No notifications"
          }
        }
      }
    }
  }
}
