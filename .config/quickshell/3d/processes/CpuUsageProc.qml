// processes/CpuUsageProc.qml
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property alias running: cpuUsageProc.running

	property bool valid: false
	property int cpuUsage

	Process {
		id: cpuUsageProc
		command: [Quickshell.shellDir + "/scripts/cpu-usage.sh"]
		stdout: StdioCollector {
			onStreamFinished: {
				if (text) {
					root.cpuUsage = parseInt(text);
					root.valid = true;
				} else {
					root.valid = false;
				}
			}
		}
	}
}
