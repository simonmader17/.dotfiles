// components/NotificationGroup.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

import ".."

// One app's notifications in the notification center. A single notification
// is just its card. Several get a header (app name, count, expand/collapse,
// dismiss all) and are collapsed to the newest card with a stack peeking out
// below it, or expanded to all cards. The expanded state lives in
// Notifications.expandedGroups.
Item {
  id: root

  readonly property string appName: Notifications.byKey[root.members[0]]
                                    ?.appName || "Notification"
  readonly property bool collapsed: root.multi && !root.expanded
  // Day header shown above the group ("Today", ...), empty for none
  property string dayHeader: ""
  readonly property bool expanded: root.multi && !
                                   !Notifications.expandedGroups[root.groupKey]
  required property string groupKey
  readonly property var members: Notifications.groupMembers[root.groupKey] ?? []
  readonly property bool multi: root.members.length > 1
  readonly property int peekHeight: 8

  height: implicitHeight
  implicitHeight: column.implicitHeight

  ColumnLayout {
    id: column

    spacing: 4
    width: root.width

    // Day header, above the first group of each day
    Text {
      Layout.leftMargin: 2
      Layout.topMargin: 4
      color: Pywal.foreground
      font.bold: true
      font.family: Globals.myFont.family
      font.pixelSize: 12
      opacity: 0.7
      text: root.dayHeader
      visible: root.dayHeader !== ""
    }

    // Header, only for several notifications
    Item {
      Layout.fillWidth: true
      Layout.leftMargin: 2
      Layout.rightMargin: 2
      implicitHeight: header.implicitHeight
      visible: root.multi

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: Notifications.toggleGroup(root.groupKey)
      }

      RowLayout {
        id: header

        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 6

        Text {
          color: Pywal.foreground
          font: Globals.myIconFont
          renderType: Globals.myIconFontRenderType
          text: root.expanded ? "" : "" // expand_less / expand_more
        }

        Text {
          Layout.fillWidth: true
          color: Pywal.foreground
          elide: Text.ElideRight
          font.bold: true
          font.family: Globals.myFont.family
          font.pixelSize: 14
          text: root.appName + " · " + root.members.length
        }

        // Dismiss the whole group
        Text {
          color: Pywal.foreground
          font: Globals.myIconFont
          renderType: Globals.myIconFontRenderType
          text: "" // clear_all

          MouseArea {
            anchors.fill: parent
            anchors.margins: -4
            cursorShape: Qt.PointingHandCursor

            onClicked: Notifications.dismissGroup(root.groupKey)
          }
        }
      }
    }

    // Cards, clipped so removed cards slide out of view. The height follows
    // the cards without a Behavior: animating it fights the center's
    // `displaced` transition, which then leaves groups overlapping.
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: cards.contentHeight + (root.collapsed
                                                     ? root.peekHeight : 0)
      clip: true

      // Stack peeking out below the newest card while collapsed
      Repeater {
        model: 2

        Rectangle {
          required property int index

          color: Qt.darker(Pywal.color4, 1.3 + 0.3 * index)
          height: root.peekHeight / 2
          radius: 2
          visible: root.collapsed
          width: parent.width - 2 * x
          x: (index + 1) * 6
          y: cards.contentHeight + index * (root.peekHeight / 2)
        }
      }

      MouseArea {
        cursorShape: Qt.PointingHandCursor
        height: root.peekHeight
        visible: root.collapsed
        width: parent.width
        y: cards.contentHeight

        onClicked: Notifications.toggleGroup(root.groupKey)
      }

      ListView {
        id: cards

        height: contentHeight
        interactive: false
        spacing: 6
        width: parent.width

        add: Transition {
          NumberAnimation {
            duration: 180
            from: 0
            property: "opacity"
            to: 1
          }
        }

        // The wrapper takes the view transitions, so they never touch the
        // card's own swipe translation and opacity
        delegate: Item {
          id: slot

          required property string modelData

          height: card.height
          width: card.width

          NotificationCard {
            id: card

            clickExpands: root.collapsed
            contentWidth: cards.width - 2 * paddingX
            notification: Notifications.byKey[slot.modelData] ?? null
            swipeDismissesGroup: root.collapsed

            onExpandRequested: Notifications.toggleGroup(root.groupKey)
            onGroupDismissRequested: Notifications.dismissGroup(root.groupKey)
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
          values: root.expanded ? root.members : root.members.slice(0, 1)
        }
        remove: Transition {
          NumberAnimation {
            duration: 180
            easing.type: Easing.InCubic
            property: "x"
            to: cards.width
          }
        }
      }
    }
  }
}
