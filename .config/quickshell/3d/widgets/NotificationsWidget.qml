// widgets/NotificationsWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../components"

import ".."

// Left click toggles the notification center, right click toggles
// "Do not disturb". Shows the number of unread notifications (arrived since
// the center was last open).
My3dButton {
  id: root

  acceptedButtons: Qt.LeftButton | Qt.RightButton
  forcePressed: Notifications.centerOpen && Notifications.centerScreen
                === root.QsWindow.window?.screen?.name

  onClicked: Notifications.toggleCenter(root.QsWindow.window?.screen?.name
                                        ?? "")
  onRightClicked: Notifications.toggleDnd()

  RowLayout {
    id: row

    Text {
      font: Globals.myFont
      text: Notifications.unreadCount
      visible: Notifications.unreadCount > 0
    }

    Text {
      font: Globals.myIconFont
      renderType: Globals.myIconFontRenderType
      text: {
        if (Notifications.dnd) {
          return ""; // notifications_off
        }
        if (Notifications.unreadCount > 0) {
          return ""; // notifications_unread
        }
        return ""; // notifications
      }
    }
  }

  HoverHandler {
    id: hoverHandler
  }

  My3dToolTip {
    anchorItem: row
    baseColor: Qt.darker(root.baseColor, 2)
    text: Notifications.unreadCount + " unread · " + Notifications.count
          + " total" + "\nDo not disturb: " + (Notifications.dnd ? "on" :
                                                                   "off") + "\nRight click to toggle DND"
    visible: hoverHandler.hovered && !Notifications.centerOpen
  }
}
