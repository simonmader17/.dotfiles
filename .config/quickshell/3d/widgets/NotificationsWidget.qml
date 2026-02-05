// widgets/NotificationsWidget.qml
import QtQuick
import Quickshell

import ".."
import "../components"

My3dButton {
	onClicked: Quickshell.execDetached(["swaync-client", "-t"])

	Text {
		font: Globals.myIconFont
		renderType: Globals.myIconFontRenderType
		text: "\ue7f4" // notifications
	}
}
