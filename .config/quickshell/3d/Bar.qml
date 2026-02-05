// Bar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

import "processes"
import "widgets"

Scope {
	Variants {
		model: Quickshell.screens
		Scope {
			id: root

			required property var modelData

			// Left bar (only on small screens)
			PanelWindow {
				id: leftBar

				visible: root.modelData.height <= 1080

				screen: root.modelData
				color: "transparent"
				implicitWidth: workspaces.implicitWidth + 4
				anchors {
					top: true
					bottom: true
					left: true
				}

				// Background
				Rectangle {
					anchors.fill: parent
					color: Colors.background
					opacity: 0.8
					Rectangle {
						anchors.right: parent.right
						anchors.bottom: parent.bottom
						width: 8
						height: parent.height - topBar.height + 8
						color: Qt.darker(parent.color, 1.2)
						opacity: 0.8
					}
				}

				WorkspacesWidget {
					id: workspaces
					screen: leftBar.screen
					smallScreen: true
				}
			}

			// Top bar
			PanelWindow {
				id: topBar

				screen: root.modelData
				color: "transparent"
				implicitHeight: Math.max(leftWidgets.implicitHeight, rightWidgets.implicitHeight)
				anchors {
					top: true
					left: true
					right: true
				}

				// Background
				Rectangle {
					anchors.fill: parent
					color: Colors.background
					opacity: 0.8
					Rectangle {
						anchors.bottom: parent.bottom
						width: parent.width
						height: 8
						color: Qt.darker(parent.color, 1.2)
						opacity: 0.8
					}
				}

				// Left widgets
				RowLayout {
					id: leftWidgets

					spacing: 4
					anchors {
						left: parent.left
						top: parent.top
						bottom: parent.bottom
					}

					WorkspacesWidget {
						screen: topBar.screen
						visible: screen.height > 1080
					}

					WindowWidget {}
				}

				// Right widgets
				RowLayout {
					id: rightWidgets

					spacing: 4
					anchors {
						right: parent.right
						top: parent.top
						bottom: parent.bottom
					}

					TrayWidget {}

					AudioWidget {}

					CpuMemWidget {}

					NetworkWidget {}

					BatteryWidget {}

					ClockWidget {}

					NotificationsWidget {}
				}
			}
		}
	}

	Timer {
		interval: 2000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			BatteryProc.running = true
			CpuTempProc.running = true
			CpuUsageProc.running = true
			MemoryProc.running = true
			NetworkProc.running = true
		}
	}
}
