// widgets/ClockWidget.qml
import QtQuick

import ".."
import "../components"

My3dRectangle {
  baseColor: Pywal.color6

  Text {
    font: Globals.myFont
    text: Time.time
  }

  Text {
    font: Globals.myIconFont
    renderType: Globals.myIconFontRenderType
    text: "\uebcc" // calendar-month
  }
}
