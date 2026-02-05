// processes/NetworkProc.qml
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property alias running: networkProc.running

	property bool valid: false
	property string iface
	property string rx
	property string rx_total
	property string tx
	property string tx_total
	property int quality

	Process {
		id: networkProc
		command: [Quickshell.shellDir + "/scripts/network.sh"]
		stdout: StdioCollector {
			onStreamFinished: {
				if (text) {
					var p = text.split(";")
					root.iface = p[0]
					root.rx = p[1]
					root.rx_total = p[2]
					root.tx = p[3]
					root.tx_total = p[4]
					root.quality = parseInt(p[5])
					root.valid = true
				} else {
					root.valid = false
				}
			}
		}
	}
}
