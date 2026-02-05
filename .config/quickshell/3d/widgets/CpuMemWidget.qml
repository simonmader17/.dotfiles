// widgets/CpuMemWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

import ".."
import "../components"
import "../processes"

My3dButton {
	id: root

	visible: CpuUsageProc.valid || CpuTempProc.valid || MemoryProc.valid
	baseColor: Colors.color5
	
	onClicked: Quickshell.execDetached(["missioncenter"])

	RowLayout {
		spacing: 3

		RowLayout {
			visible: CpuUsageProc.valid
			spacing: 2

			Text {
				font: Globals.myFont
				text: CpuUsageProc.cpuUsage + "%"
			}
			Text {
				font: Globals.myIconFont
				renderType: Globals.myIconFontRenderType
				Layout.rightMargin: 4
				text: "\ue322" // memory
			}
		}

		RowLayout {
			visible: CpuTempProc.valid
			spacing: 2

			Text {
				font: Globals.myFont
				text: CpuTempProc.cpuTemp + "°C"
			}
			Text {
				font: Globals.myIconFont
				renderType: Globals.myIconFontRenderType
				Layout.rightMargin: 4
				text: "\uf076" // thermostat
			}
		}

		RowLayout {
			id: memRowLayout

			visible: MemoryProc.valid
			spacing: 2

			Text {
				font: Globals.myFont
				text: MemoryProc.memoryUsage + "%"
			}
			Text {
				font: Globals.myIconFont
				renderType: Globals.myIconFontRenderType
				text: "\uf7a3" // memory-alt
			}

			HoverHandler {
				id: memHoverHandler
			}
			My3dToolTip {
				anchorItem: memRowLayout
				baseColor: Qt.darker(root.baseColor, 2)
				text: MemoryProc.memoryUsed + "GiB used out of " + MemoryProc.memoryTotal + "GiB"
				visible: memHoverHandler.hovered
			}
		}
	}
}
