// widgets/NetworkWidget.qml
import QtQuick
import QtQuick.Layouts

import ".."
import "../components"
import "../helper.js" as Helper
import "../processes"

My3dRectangle {
	id: root

	visible: NetworkProc.valid
	baseColor: Colors.color2

	RowLayout {
		id: rowLayout

		Text {
			font: Globals.myIconFont
			renderType: Globals.myIconFontRenderType
			text: "\uf090" // download
		}
		Text {
			font: Globals.myFont
			text: NetworkProc.rx
		}
		Text {
			font: Globals.myIconFont
			renderType: Globals.myIconFontRenderType
			text: "\uf09b" // upload
		}
		Text {
			font: Globals.myFont
			text: NetworkProc.tx
		}
		Text {
			font: Globals.myIconFont
			renderType: Globals.myIconFontRenderType
			text: {
				if (NetworkProc.iface.startsWith("e")) {
					return "\ueb2f" // lan
				} else if (NetworkProc.iface.startsWith("w")) {
					if (NetworkProc.quality == -1) {
						return "\ue1d8" // signal-wifi-4-bar
					}
					return Helper.chooseIconBasedOnPercentage(
						[
							"\uf0b0", // signal-wifi-0-bar
							"\uebe4", // signal-wifi-1-bar
							"\uebd6", // signal-wifi-2-bar
							"\uebe1", // signal-wifi-3-bar
							"\ue1d8", // signal-wifi-4-bar
						],
						NetworkProc.quality / 100
					)
				} else {
					return "\ueb8b" // question-mark
				}
			}
		}

		HoverHandler {
			id: hoverHandler
		}
		My3dToolTip {
			visible: hoverHandler.hovered
			anchorItem: rowLayout
			baseColor: Qt.darker(root.baseColor, 2)
			text: "Interface: " + NetworkProc.iface + "\n"
				+ "Download: " + NetworkProc.rx + " (Total: " + NetworkProc.rx_total + ")\n"
				+ "Upload: " + NetworkProc.tx + " (Total: " + NetworkProc.tx_total + ")"
				+ (NetworkProc.quality != -1 ? "\nQuality: " + NetworkProc.quality + "%" : "")
		}
	}
}
