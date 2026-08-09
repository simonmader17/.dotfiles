// processes/BatteryProc.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property alias running: batteryProc.running

  property bool valid: false
  property int acOnline: 0
  property bool charging: false

  readonly property alias batteries: batteryModel
  ListModel {
    id: batteryModel
  }

  Process {
    id: batteryProc
    command: [Quickshell.shellDir + "/scripts/battery.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        if (text) {
          const lines = text.trim().split("\n").filter(line => line !== "");
          if (lines.length < 2) {
            batteryModel.clear();
            root.charging = false;
            root.valid = false;
            return;
          }

          root.acOnline = parseInt(lines[0]);

          const batteries = lines.slice(1).map(line => {
            const p = line.split(";");
            return {
              capacity: parseInt(p[0]),
              status: p[1],
              powerNow: parseInt(p[2]),
              energyNow: parseInt(p[3]),
              energyFull: parseInt(p[4]),
              energyFullDesign: parseInt(p[5]),
              voltageNow: parseInt(p[6]),
              voltageMinDesign: parseInt(p[7]),
              manufacturer: p[8],
              modelName: p[9],
            };
          });

          if (batteryModel.count !== batteries.length) {
            batteryModel.clear();
            for (const battery of batteries) {
              batteryModel.append(battery);
            }
          } else {
            for (let i = 0; i < batteries.length; i++) {
              batteryModel.set(i, batteries[i]);
            }
          }

          root.charging = batteries.some(battery => battery.status === "Charging");
          root.valid = true;
        } else {
          root.valid = false;
          root.acOnline = 0;
          root.charging = false;
        }
      }
    }
  }
}
