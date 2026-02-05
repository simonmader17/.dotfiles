// widgets/AudioWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import ".."
import "../components"
import "../helper.js" as Helper

My3dRectangle {
	id: root

	readonly property var sink: Pipewire.defaultAudioSink
	readonly property var source: Pipewire.defaultAudioSource

	PwObjectTracker {
		objects: [root.sink, root.source]
	}

	RowLayout {
		// Speaker
		Item {
			implicitWidth: rowLayoutSink.implicitWidth
			implicitHeight: rowLayoutSink.implicitHeight

			RowLayout {
				id: rowLayoutSink

				Text {
					visible: !root.sink?.audio.muted
					font: Globals.myFont
					text: Math.round(root.sink?.audio.volume * 100 || 0) + "%"
				}

				Text {
					font: Globals.myIconFont
					renderType: Globals.myIconFontRenderType
					text: {
						if (!root.sink) {
							return "\uf4f3"
						}
						if (root.sink.audio.muted) {
							return "\ue04f"
						}
						return Helper.chooseIconBasedOnPercentage(
							[
								"\ue04e",
								"\ue04d",
								"\ue050",
							],
							root.sink?.audio.volume || 0
						)
					}
				}

				HoverHandler {
					id: hoverHandlerSink
				}
				My3dToolTip {
					visible: hoverHandlerSink.hovered
					anchorItem: rowLayoutSink
					baseColor: Qt.darker(root.baseColor, 2)
					text: "Name: " + root.sink?.name + "\n"
						+ "Nickname: " + root.sink?.nickname + "\n"
						+ "Description: " + root.sink?.description
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (root.sink) {
						root.sink.audio.muted = !root.sink.audio.muted
					}
				}
				onWheel: (event) => {
					if (root.sink) {
						root.sink.audio.volume = Math.min(1, root.sink.audio.volume + (event.angleDelta.y / 120) * 0.05)
					}
				}
			}
		}
		// Microphone
		Item {
			implicitWidth: rowLayoutSource.implicitWidth
			implicitHeight: rowLayoutSource.implicitHeight

			RowLayout {
				id: rowLayoutSource

				Text {
					visible: !root.source?.audio.muted
					font: Globals.myFont
					text: Math.round(root.source?.audio.volume * 100 || 0) + "%"
				}
				Text {
					font: Globals.myIconFont
					renderType: Globals.myIconFontRenderType
					text: {
						if (!root.source) {
							return "\uf392"
						}
						if (root.source.audio.muted) {
							return "\ue02b"
						}
						return "\ue029"
					}
				}

				HoverHandler {
					id: hoverHandlerSource
				}
				My3dToolTip {
					visible: hoverHandlerSource.hovered
					anchorItem: rowLayoutSource
					baseColor: Qt.darker(root.baseColor, 2)
					text: "Name: " + root.source?.name + "\n"
						+ "Nickname: " + root.source?.nickname + "\n"
						+ "Description: " + root.source?.description
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (root.source) {
						root.source.audio.muted = !root.source.audio.muted
					}
				}
				onWheel: (event) => {
					if (root.source) {
						root.source.audio.volume = Math.min(1, root.source.audio.volume + (event.angleDelta.y / 120) * 0.05)
					}
				}
			}
		}
	}
}
