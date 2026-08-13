// widgets/TrayWidget.qml
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import ".."
import "../components"
import "../helper.js" as Helper

My3dRectangle {
  id: root

  baseColor: Colors.color2

  readonly property var keepOwnColors: [
    "blueman",
  ]

  RowLayout {
    Repeater {
      model: {
        let trayItems = [...SystemTray.items.values]
        trayItems.sort((i1, i2) => i1.title.localeCompare(i2.title))
        return trayItems;
      }

      Item {
        id: trayItem

        required property SystemTrayItem modelData
        readonly property bool recolor: !root.keepOwnColors.some(
          pattern => modelData.id.toLowerCase().includes(pattern)
        )

        implicitWidth: icon.implicitWidth
        implicitHeight: icon.implicitHeight

        IconImage {
          id: icon

          source: trayItem.modelData.icon
          implicitWidth: 21
          implicitHeight: 21

          layer.enabled: trayItem.recolor
          layer.effect: MultiEffect {
            contrast: -1
            brightness: 0.5
            colorization: 1
            colorizationColor: Helper.contrastColor(
              root.baseColor,
              Colors.background,
              Colors.foreground
            )
          }
        }

        MouseArea {
          id: mouseArea

          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: (mouse) => {
            if (mouse.button == Qt.RightButton || trayItem.modelData.onlyMenu) {
              if (trayItem.modelData.hasMenu) menu.open();
            } else {
              trayItem.modelData.activate();
            }
          }
        }

        QsMenuAnchor {
          id: menu

          anchor.item: trayItem
          anchor.edges: Edges.Bottom | Edges.Left
          menu: trayItem.modelData.menu
        }

        HoverHandler {
          id: hoverHandler
        }
        My3dToolTip {
          visible: hoverHandler.hovered
          anchorItem: trayItem
          baseColor: Qt.darker(root.baseColor, 2)
          text: trayItem.modelData.tooltipTitle ||
            trayItem.modelData.tooltipDescription ||
            trayItem.modelData.title ||
            ""
        }
      }
    }
  }
}
