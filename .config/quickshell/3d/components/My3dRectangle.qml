// components/My3dRectangle.qml
import QtQuick
import QtQuick.Layouts

import ".."
import "../helper.js" as Helper

Item {
	id: root

	default property alias content: content.data
	property bool pressed: false
	property color baseColor: Colors.color1
	property color textColor
	property int depth: 4 // The "height" of the 3D effect
	property int paddingX: 15
	property int paddingY: 8

	function applyTextColorRecursively(node) {
		for (var i = 0; i < node.children.length; i++) {
			let child = node.children[i];
			if (child.hasOwnProperty("text") && "color" in child && !child.colorSet) {
				if (root.textColor.valid) {
					child.color = Qt.binding(() => root.textColor)
				} else {
					child.color = Qt.binding(() => Helper.contrastColor(
						root.baseColor,
						Colors.background,
						Colors.foreground
					))
				}
			}
			if (child.children.length > 0) {
				applyTextColorRecursively(child);
			}
		}
	}

	implicitWidth: content.implicitWidth + 2 * paddingX > 46 ? content.implicitWidth + 2 * paddingX : 46
	implicitHeight: content.implicitHeight + 2 * paddingY > 46 ? content.implicitHeight + 2 * paddingY : 46
	
	Component.onCompleted: applyTextColorRecursively(root)

	// depth layer (shadow)
	Rectangle {
		anchors.fill: parent
		anchors.topMargin: root.depth
		color: Qt.darker(root.baseColor, 1.4)
		radius: 5
	}

	// face layer
	Rectangle {
		anchors.fill: parent
		anchors.topMargin: root.pressed ? root.depth : 0
		anchors.bottomMargin: root.pressed ? 0 : root.depth
		color: root.baseColor
		radius: 5

		RowLayout {
			id: content
			anchors.centerIn: parent
		}
	}
}
