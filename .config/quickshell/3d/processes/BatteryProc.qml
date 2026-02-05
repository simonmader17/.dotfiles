// processes/BatteryProc.qml
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property alias running: batteryProc.running

	property bool valid: false
	property int capacity
	property string status
	property int acOnline
	property int powerNow
	property int energyNow
	property int energyFull
	property int energyFullDesign
	property int voltageNow
	property int voltageMinDesign
	property string manufacturer
	property string modelName

	Process {
		id: batteryProc
		command: [Quickshell.shellDir + "/scripts/battery.sh"]
		stdout: StdioCollector {
			onStreamFinished: {
				if (text) {
					var p = text.split(";");
					root.capacity = parseInt(p[0]);
					root.status = p[1];
					root.acOnline = parseInt(p[2]);
					root.powerNow = parseInt(p[3]);
					root.energyNow = parseInt(p[4]);
					root.energyFull = parseInt(p[5]);
					root.energyFullDesign = parseInt(p[6]);
					root.voltageNow = parseInt(p[7]);
					root.voltageMinDesign = parseInt(p[8]);
					root.manufacturer = p[9];
					root.modelName = p[10];
					root.valid = true;
				} else {
					root.valid = false;
				}
			}
		}
	}
}
