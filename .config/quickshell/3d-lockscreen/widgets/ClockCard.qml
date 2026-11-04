import ".."
import "../components"
// widgets/ClockCard.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

My3dRectangle {
    id: root

    baseColor: Pywal.color6
    depth: 8
    paddingX: 48
    paddingY: 20

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    ColumnLayout {
        spacing: 0

        Text {
            Layout.alignment: Qt.AlignHCenter
            font.family: Globals.myFont.family
            font.pixelSize: 96
            font.bold: true
            text: Qt.formatDateTime(clock.date, "hh:mm")
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Text {
                font.family: Globals.myFont.family
                font.pixelSize: 20
                font.bold: true
                text: Qt.formatDateTime(clock.date, "dddd, d MMMM")
            }

            Text {
                font: Globals.myIconFont
                renderType: Globals.myIconFontRenderType
                text: "" // calendar-month
            }

        }

    }

}
