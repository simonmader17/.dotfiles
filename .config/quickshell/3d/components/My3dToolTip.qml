// components/My3dToolTip.qml
import QtQuick
import Quickshell

import ".."
import "../components"

Scope {
	id: root

	property alias baseColor: toolTipContent.baseColor
	property bool visible: false
	required property Item anchorItem
	required property string text

	PopupWindow {
		id: toolTip

		visible: root.visible && toolTipContentText.text
		color: "transparent"
		implicitWidth: toolTipContent.implicitWidth
		implicitHeight: toolTipContent.implicitHeight
		anchor.item: root.anchorItem
		anchor.edges: Edges.Bottom | Edges.Left

		My3dRectangle {
			id: toolTipContent

			baseColor: Colors.background

			Text {
				id: toolTipContentText
				text: root.text
				font: Globals.myFont
			}
		}
	}
}
