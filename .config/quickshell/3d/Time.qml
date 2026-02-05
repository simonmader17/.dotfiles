// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: root

	readonly property string time: Qt.formatDateTime(systemClock.date, "ddd d MMM, hh:mm")

	SystemClock {
		id: systemClock

		precision: SystemClock.Minutes
	}
}
