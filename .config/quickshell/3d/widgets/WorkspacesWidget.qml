// widgets/WorkspacesWidget.qml
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import ".."
import "../components"

GridLayout {
  id: root

  required property var screen
  property bool smallScreen: false

  columns: smallScreen ? 1 : -1
  rows: smallScreen ? -1 : 1
  columnSpacing: 4
  rowSpacing: 4

  Repeater {
    model: Hyprland.workspaces.values

    Item {
      id: box

      required property HyprlandWorkspace modelData
      property HyprlandWorkspace ws: modelData
      property bool iconPressed: false

      visible: ws.monitor == Hyprland.monitorFor(root.screen)
      implicitWidth: button.implicitWidth
      implicitHeight: button.implicitHeight

      HoverHandler {
        id: hoverHandler
      }
      My3dToolTip {
        visible: hoverHandler.hovered
        anchorItem: button
        baseColor: button.baseColor
        paddingX: 8
        paddingY: 8
        content: Component {
          WorkspacePreview {
            ws: box.ws
            frameColor: button.baseColor
          }
        }
      }

      My3dButton {
        id: button

        forcePressed: box.iconPressed
        baseColor: box.ws.active ? Pywal.color1 : Qt.darker(Pywal.color1, 1.5)
        paddingX: root.smallScreen ? 8 : 15
        paddingY: root.smallScreen ? 15 : 8

        onClicked: box.ws.activate()

        GridLayout {
          id: inner

          columns: root.smallScreen ? 1 : -1
          rows: root.smallScreen ? -1 : 1

          Text {
            id: text

            Layout.alignment: Qt.AlignCenter
            font: Globals.myFont
            text: box.ws.name
          }

          Repeater {
            model: box.ws.name !== "✉️" ? box.ws.toplevels.values : []

            Item {
              id: icon

              required property var modelData

              visible: iconImage.source.toString() !== ""
              implicitWidth: 1.5 * text.implicitHeight
              implicitHeight: 1.5 * text.implicitHeight

              IconImage {
                id: iconImage

                anchors.fill: parent
                source: {
                  var id = icon.modelData?.wayland?.appId;
                  return Quickshell.iconPath(Globals.guessIcon(id), true)
                }
              }

              MultiEffect {
                id: multiEffect

                source: iconImage
                anchors.fill: iconImage

                visible: icon.modelData.activated || icon.modelData.urgent

                shadowEnabled: true
                shadowBlur: icon.modelData.urgent ? 0.5 : 0
                shadowScale: 1.1
                shadowColor: icon.modelData.urgent ? "red" : "white"

                SequentialAnimation {
                  loops: Animation.Infinite
                  running: icon.modelData.urgent
                  NumberAnimation {
                    target: multiEffect
                    properties: "shadowScale"
                    from: 1.1
                    to: 1.3
                    duration: 1000
                    easing.type: Easing.InOutQuad
                  }
                  NumberAnimation {
                    target: multiEffect
                    properties: "shadowScale"
                    from: 1.3
                    to: 1.1
                    duration: 1000
                    easing.type: Easing.InOutQuad
                  }
                  onStopped: {
                    multiEffect.shadowScale = 1.1
                  }
                }
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressedChanged: box.iconPressed = pressed
                onReleased: mouse => {
                  // Focus if released anywhere inside the workspace button,
                  // not only on the icon itself
                  if (!button.contains(mapToItem(button, mouse.x, mouse.y))) {
                    return;
                  }
                  Quickshell.execDetached([
                    Quickshell.shellDir + "/scripts/focus-window.sh",
                    icon.modelData.address
                  ]);
                }
              }
            }
          }
        }
      }
    }
  }
}
