// widgets/MediaWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Mpris

import ".."
import "../components"
import "../helper.js" as Helper

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
			visible: source.toString() !== ""
		}
		Item {
			id: equalizerLeft

			readonly property int barCount: 3
			property var levels: new Array(barCount).fill(0)

			implicitWidth: 21
			implicitHeight: 16

			Process {
				id: cavaLeft

				running: true
				command: ["cava", "-p", "/dev/stdin"]
				stdinEnabled: true

				stdout: SplitParser {
					splitMarker: "\n"
					onRead: (line) => {
						const parts = line.trim().split(";").filter(s => s.length)
						if (parts.length === equalizerLeft.barCount) {
							equalizerLeft.levels = parts.map(v => parseInt(v) / 100)
						}
					}
				}

				onStarted: {
					cavaLeft.write(
						"[general]\n" +
						"bars=" + equalizerLeft.barCount + "\n" +
						"framerate=60\n" +
						"autosens=1\n" +
						"[output]\n" +
						"channels=mono\n" +
						"mono_option=left\n" +
						"method=raw\n" +
						"raw_target=/dev/stdout\n" +
						"data_format=ascii\n" +
						"ascii_max_range=100"
					)
					cavaLeft.stdinEnabled = false
				}
			}

			RowLayout {
				id: equalizerLeftRowLayout

				spacing: 3
				anchors.fill: parent

				Repeater {
					model: equalizerLeft.barCount

					Item {
						Layout.fillWidth: true
						Layout.fillHeight: true

						Rectangle {
							id: bar

							anchors.bottom: parent.bottom
							width: parent.width
							height: Math.max(0.3 * equalizerLeft.height,
								Math.pow(equalizerLeft.levels[index], 0.6) * equalizerLeft.height)
							radius: 2
							color: Helper.contrastColor(Colors.color4, Colors.background, Colors.foreground)
						}
					}
				}
			}
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
			property var levels: new Array(barCount).fill(0)

			implicitWidth: 21
			implicitHeight: 16

			Process {
				id: cava

				running: true
				command: ["cava", "-p", "/dev/stdin"]
				stdinEnabled: true

				stdout: SplitParser {
					splitMarker: "\n"
					onRead: (line) => {
						const parts = line.trim().split(";").filter(s => s.length)
						if (parts.length === equalizer.barCount) {
							equalizer.levels = parts.map(v => parseInt(v) / 100)
						}
					}
				}

				onStarted: {
					cava.write(
						"[general]\n" +
						"bars=" + equalizer.barCount + "\n" +
						"framerate=60\n" +
						"autosens=1\n" +
						"[output]\n" +
						"channels=mono\n" +
						"mono_option=right\n" +
						"reverse=1\n" +
						"method=raw\n" +
						"raw_target=/dev/stdout\n" +
						"data_format=ascii\n" +
						"ascii_max_range=100"
					)
					cava.stdinEnabled = false
				}
			}

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
							height: Math.max(0.3 * equalizer.height,
								Math.pow(equalizer.levels[index], 0.6) * equalizer.height)
							radius: 2
							color: Helper.contrastColor(Colors.color4, Colors.background, Colors.foreground)
						}
					}
				}
			}
		}
	}
}
