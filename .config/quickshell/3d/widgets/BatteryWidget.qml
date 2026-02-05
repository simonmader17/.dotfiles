// widgets/BatteryWidget.qml
import QtQuick
import QtQuick.Layouts

import ".."
import "../components"
import "../helper.js" as Helper
import "../processes"

My3dRectangle {
	id: root

	visible: BatteryProc.valid
	baseColor: Colors.color4

	RowLayout {
		id: rowLayout

		Text {
			font: Globals.myFont
			text: (BatteryProc.status !== "Charging" && BatteryProc.acOnline) ? "AC" : BatteryProc.capacity + "%"
		}

		// Battery icon
		Text {
			readonly property bool colorSet: true

			font: Globals.myIconFont
			renderType: Globals.myIconFontRenderType

			color: {
				if (BatteryProc.status == "Charging") {
					return Helper.contrastColor(root.baseColor, Qt.darker(root.baseColor, 1.5), Qt.lighter(root.baseColor, 1.5))
				} else if (BatteryProc.capacity <= 20) {
					return "red"
				} else {
					return Helper.contrastColor(root.baseColor, Colors.background, Colors.foreground)
				}
			}

			text: {
				if (BatteryProc.status !== "Charging" && BatteryProc.acOnline) {
					return "\ue63c" // power
				}
				return Helper.chooseIconBasedOnPercentage(
					[
						"\uf306", // battery-android-alert
						"\uf30c", // battery-android-1
						"\uf30b", // battery-android-2
						"\uf30a", // battery-android-3
						"\uf309", // battery-android-4
						"\uf308", // battery-android-5
						"\uf307", // battery-android-6
						"\uf304", // battery-android-full
					],
					BatteryProc.capacity / 100
				)
			}
			// Overlay charging icon
			Text {
				visible: BatteryProc.status == "Charging"
				anchors.centerIn: parent
				font: Globals.myIconFontOutlined
				renderType: Globals.myIconFontRenderType
				text: "\uf305" // battery-android-bolt
			}
		}

		HoverHandler {
			id: hoverHandler
		}
		My3dToolTip {
			visible: hoverHandler.hovered
			anchorItem: rowLayout
			baseColor: Qt.darker(root.baseColor, 2)

			function r(value) {
				return Math.round(value * 10) / 10
			}
			function f(value) {
				return r(value / 1_000_000)
			}
			function remainingTime() {
				if (BatteryProc.powerNow === 0) {
					return "No power draw detected."
				}
				const totalSeconds = Math.floor((BatteryProc.status === "Discharging" ? BatteryProc.energyNow : BatteryProc.energyFull - BatteryProc.energyNow) / BatteryProc.powerNow * 3600)
				const label = `Time until ${BatteryProc.status === "Discharging" ? "empty" : "full"}`
				if (totalSeconds >= 3600) {
					const h = Math.floor(totalSeconds / 3600)
					const m = Math.floor((totalSeconds % 3600) / 60)
					return `${label}: ${h}h ${m}m remaining`
				}
				if (totalSeconds >= 60) {
					const m = Math.floor(totalSeconds / 60)
					return `${label}: ${m} minutes remaining`
				}
				return `${label}: ${totalSeconds} seconds remaining`
			}

			text: "Model: " + BatteryProc.manufacturer + " " + BatteryProc.modelName + "\n"
				+ "Power draw: " + f(BatteryProc.powerNow) + "W\n"
				+ "Charge: " + Math.round(BatteryProc.energyNow / BatteryProc.voltageNow * 1000) + "mAh / " + f(BatteryProc.energyNow) + "Wh\n"
				+ remainingTime() + "\n"
				+ "Health: " + (BatteryProc.energyFull / BatteryProc.energyFullDesign * 100) + "%\n"
				+ "Full charge: " + Math.round(BatteryProc.energyFull / BatteryProc.voltageNow * 1000) + "mAh / " + f(BatteryProc.energyFull) + "Wh\n"
				+ "Full design charge: " + Math.round(BatteryProc.energyFullDesign / BatteryProc.voltageMinDesign * 1000) + "mAh / " + f(BatteryProc.energyFullDesign) + "Wh"
		}
	}
}
