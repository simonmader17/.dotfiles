// widgets/WindowWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import ".."
import "../components"
import "../helper.js" as Helper

My3dRectangle {
	id: root

	visible: Hyprland.activeToplevel != null && Hyprland.activeToplevel.workspace.active
	baseColor: Colors.color8
	textColor: Helper.contrastColor(baseColor, "black", "white")

	RowLayout {
		Layout.maximumWidth: 350

		IconImage {
			source: {
				var id = Hyprland.activeToplevel?.wayland?.appId;
				return Quickshell.iconPath(Globals.guessIcon(id), true)
			}
			visible: source.toString() !== ""
			implicitWidth: 1.5 * title.implicitHeight
			implicitHeight: 1.5 * title.implicitHeight
		}

		Text {
			id: title

			Layout.fillWidth: true
			elide: Text.ElideRight
			font: Globals.myFont
			text: Hyprland.activeToplevel?.title || ""
		}
	}
}
