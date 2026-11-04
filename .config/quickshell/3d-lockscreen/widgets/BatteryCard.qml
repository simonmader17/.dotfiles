import ".."
import "../components"
import "../helper.js" as Helper
import "../processes"
// widgets/BatteryCard.qml
// Like 3d/widgets/BatteryWidget.qml, without the tooltip
import QtQuick
import QtQuick.Layouts

My3dRectangle {
    id: root

    visible: BatteryProc.valid
    baseColor: Pywal.color4

    RowLayout {
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
                text: "" // power
            }

        }

        // Batteries
        Repeater {
            model: BatteryProc.batteries

            RowLayout {
                id: entry

                required property var model
                readonly property var battery: entry.model

                visible: !BatteryProc.acOnline || BatteryProc.charging
                // Delegates are created after the My3dRectangle completed
                Component.onCompleted: root.applyTextColorRecursively(entry)

                Text {
                    font: Globals.myFont
                    text: entry.battery.capacity + "%"
                }

                // Battery icon
                Text {
                    // battery-android-alert
                    // battery-android-1
                    // battery-android-2
                    // battery-android-3
                    // battery-android-4
                    // battery-android-5
                    // battery-android-6
                    // battery-android-full

                    readonly property bool colorSet: true

                    font: Globals.myIconFont
                    renderType: Globals.myIconFontRenderType
                    color: {
                        if (entry.battery.status == "Charging")
                            return Helper.contrastColor(root.baseColor, Qt.darker(root.baseColor, 1.5), Qt.lighter(root.baseColor, 1.5));
                        else if (entry.battery.capacity <= 20)
                            return "red";
                        else
                            return Helper.contrastColor(root.baseColor, Pywal.background, Pywal.foreground);
                    }
                    text: Helper.chooseIconBasedOnPercentage(["", "", "", "", "", "", "", ""], entry.battery.capacity / 100)

                    // Overlay charging icon
                    Text {
                        visible: entry.battery.status == "Charging"
                        anchors.centerIn: parent
                        font: Globals.myIconFontOutlined
                        renderType: Globals.myIconFontRenderType
                        text: "" // battery-android-bolt
                    }

                }

            }

        }

    }

}
