// widgets/MediaWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

import ".."
import "../components"

My3dRectangle {
	id: root

	readonly property var player: Mpris.players.values.filter(p => p.isPlaying)[0];

	visible: player !== undefined
	baseColor: Colors.color4

	RowLayout {
		Layout.maximumWidth: 350
		spacing: 8

		Image {
			sourceSize.height: 30
			source: root.player?.trackArtUrl || ""
		}
		Text {
			Layout.fillWidth: true
			elide: Text.ElideRight
			font: Globals.myFont
			// text: root.player?.trackArtist + " - " + root.player?.trackTitle
			text: {
				let ret = root.player?.trackArtist;
				if (ret !== "") ret += " - ";
				ret += root.player?.trackTitle;
				return ret;
			}
		}
		Item {
			id: equalizer

			readonly property int barCount: 3

			implicitWidth: 21
			implicitHeight: 16

			RowLayout {
				id: equalizerRowLayout

				spacing: 3
				anchors.fill: parent

				Repeater {
					model: equalizer.barCount

					Item {
						Layout.fillWidth: true
						Layout.fillHeight: true

						Rectangle {
							id: bar

							anchors.bottom: parent.bottom
							width: parent.width
							height: equalizer.height * 0.3
							radius: 2
							color: Colors.foreground

							SequentialAnimation on height {
								running: true
								loops: Animation.Infinite

								NumberAnimation {
									to: equalizer.height
									duration: 500 + Math.random() * 1000
									easing.type: Easing.InOutQuad
								}
								NumberAnimation {
									to: equalizer.height * 0.3
									duration: 500 + Math.random() * 1000
									easing.type: Easing.InOutQuad
								}
							}
						}
					}
				}
			}
		}
	}
}
