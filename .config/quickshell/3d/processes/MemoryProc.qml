// processes/MemoryProc.qml
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property alias running: memoryProc.running

	property bool valid: false
	property int memoryUsage
	property double memoryUsed
	property double memoryTotal

	Process {
		id: memoryProc
		command: [Quickshell.shellDir + "/scripts/memory.sh"]
		stdout: StdioCollector {
			onStreamFinished: {
				if (text) {
					var p = text.split(";")
					root.memoryUsage = parseInt(p[0])
					root.memoryUsed = parseFloat(p[1])
					root.memoryTotal = parseFloat(p[2])
					root.valid = true
				} else {
					root.valid = false
				}
			}
		}
	}
}

