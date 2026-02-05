// processes/CpuTempProc.qml
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property alias running: cpuTempProc.running

	property bool valid: false
	property int cpuTemp

	Process {
		id: cpuTempProc
		command: [Quickshell.shellDir + "/scripts/cpu-temp.sh"]
		stdout: StdioCollector {
			onStreamFinished: {
				if (text) {
					root.cpuTemp = parseInt(text);
					root.valid = true;
				} else {
					root.valid = false;
				}
			}
		}
	}
}
