// components/My3dButton.qml
import QtQuick

Item {
  id: root

  default property alias content: rect.content
  property alias baseColor: rect.baseColor
  property alias depth: rect.depth
  property alias paddingX: rect.paddingX
  property alias paddingY: rect.paddingY
  // Show the pressed state while an interactive child is pressed
  property bool forcePressed: false

  signal clicked()

  implicitWidth: rect.implicitWidth
  implicitHeight: rect.implicitHeight

  // Declared before the content so interactive children receive clicks first
  MouseArea {
    id: mouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }

  My3dRectangle {
    id: rect
    anchors.fill: parent
    pressed: mouseArea.pressed || root.forcePressed
  }
}
