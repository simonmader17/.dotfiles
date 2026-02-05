// widgets/TrayWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import ".."
import "../components"

My3dRectangle {
	id: root

	baseColor: Colors.color2

	RowLayout {
		Repeater {
			model: SystemTray.items.values

			Item {
				id: trayItem

				required property SystemTrayItem modelData

				implicitWidth: icon.implicitWidth
				implicitHeight: icon.implicitHeight

				IconImage {
					id: icon

					source: trayItem.modelData.icon
					implicitWidth: 21
					implicitHeight: 21
				}

				MouseArea {
					id: mouseArea

					anchors.fill: parent
					acceptedButtons: Qt.LeftButton | Qt.RightButton
					onClicked: (mouse) => {
						if (mouse.button == Qt.LeftButton) {
							trayItem.modelData.activate()
						} else if (mouse.button == Qt.RightButton) {
							menu.open()
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
