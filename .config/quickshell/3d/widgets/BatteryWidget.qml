// widgets/BatteryWidget.qml
import QtQuick
import QtQuick.Layouts

import ".."
import "../components"
import "../helper.js" as Helper
import "../processes"

My3dRectangle {
  id: root

  visible: BatteryProc.valid
  baseColor: Colors.color4

  RowLayout {
    id: rowLayout

    // AC indicator
    RowLayout {
      visible: BatteryProc.acOnline && !BatteryProc.charging

      Text {
        font: Globals.myFont
        text: "AC"
      }

      Text {
        font: Globals.myIconFont
        renderType: Globals.myIconFontRenderType
        text: "\ue63c" // power
      }
    }

    // Batteries
    Repeater {
      model: BatteryProc.batteries

      RowLayout {
        id: entry

        visible: !BatteryProc.acOnline || BatteryProc.charging

        required property var model
        readonly property var battery: entry.model

        // The delegates only exist once the first battery data arrives, which
        // is after the surrounding My3dRectangle completed, so the automatic
        // text coloring has to be applied here.
        Component.onCompleted: root.applyTextColorRecursively(entry)

        Text {
          font: Globals.myFont
          text: entry.battery.capacity + "%"
        }

        // Battery icon
        Text {
          readonly property bool colorSet: true

          font: Globals.myIconFont
          renderType: Globals.myIconFontRenderType

          color: {
            if (entry.battery.status == "Charging") {
              return Helper.contrastColor(root.baseColor, Qt.darker(root.baseColor, 1.5), Qt.lighter(root.baseColor, 1.5));
            } else if (entry.battery.capacity <= 20) {
              return "red";
            } else {
              return Helper.contrastColor(root.baseColor, Colors.background, Colors.foreground);
            }
          }

          text: {
            return Helper.chooseIconBasedOnPercentage(
              [
                "\uf306", // battery-android-alert
                "\uf30c", // battery-android-1
                "\uf30b", // battery-android-2
                "\uf30a", // battery-android-3
                "\uf309", // battery-android-4
                "\uf308", // battery-android-5
                "\uf307", // battery-android-6
                "\uf304", // battery-android-full
              ],
              entry.battery.capacity / 100
            );
          }
          // Overlay charging icon
          Text {
            visible: entry.battery.status == "Charging"
            anchors.centerIn: parent
            font: Globals.myIconFontOutlined
            renderType: Globals.myIconFontRenderType
            text: "\uf305" // battery-android-bolt
          }
        }

        HoverHandler {
          id: hoverHandler
        }
        My3dToolTip {
          visible: hoverHandler.hovered
          anchorItem: rowLayout
          baseColor: Qt.darker(root.baseColor, 2)

          function r(value) {
            return Math.round(value * 10) / 10;
          }

          function f(value) {
            return r(value / 1_000_000);
          }

          function remainingTime() {
            if (entry.battery.powerNow === 0) {
              return "No power draw detected.";
            }
            const totalSeconds = Math.floor((entry.battery.status === "Discharging" ? entry.battery.energyNow : entry.battery.energyFull - entry.battery.energyNow) / entry.battery.powerNow * 3600);
            const label = `Time until ${entry.battery.status === "Discharging" ? "empty" : "full"}`;
            if (totalSeconds >= 3600) {
              const h = Math.floor(totalSeconds / 3600);
              const m = Math.floor((totalSeconds % 3600) / 60);
              return `${label}: ${h}h ${m}m remaining`;
            }
            if (totalSeconds >= 60) {
              const m = Math.floor(totalSeconds / 60);
              return `${label}: ${m} minutes remaining`;
            }
            return `${label}: ${totalSeconds} seconds remaining`;
          }

          text: "Model: " + entry.battery.manufacturer + " " + entry.battery.modelName + "\n"
            + "Power draw: " + f(entry.battery.powerNow) + "W\n"
            + "Charge: " + Math.round(entry.battery.energyNow / entry.battery.voltageNow * 1000) + "mAh / " + f(entry.battery.energyNow) + "Wh\n"
            + remainingTime() + "\n"
            + "Health: " + (entry.battery.energyFull / entry.battery.energyFullDesign * 100) + "%\n"
            + "Full charge: " + Math.round(entry.battery.energyFull / entry.battery.voltageNow * 1000) + "mAh / " + f(entry.battery.energyFull) + "Wh\n"
            + "Full design charge: " + Math.round(entry.battery.energyFullDesign / entry.battery.voltageMinDesign * 1000) + "mAh / " + f(entry.battery.energyFullDesign) + "Wh"
        }
      }
    }
  }
}
