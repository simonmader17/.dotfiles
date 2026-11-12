// components/My3dButton.qml
import QtQuick

Item {
  id: root

  // Add Qt.RightButton / Qt.MiddleButton to receive rightClicked() /
  // middleClicked()
  property alias acceptedButtons: mouseArea.acceptedButtons
  property alias baseColor: rect.baseColor
  default property alias content: rect.content
  property alias depth: rect.depth
  // Show the pressed state while an interactive child is pressed
  property bool forcePressed: false
  property alias paddingX: rect.paddingX
  property alias paddingY: rect.paddingY

  signal clicked
  signal middleClicked
  signal rightClicked

  // For text created after the button (e.g. Repeater delegates)
  function applyTextColorRecursively(node) {
    rect.applyTextColorRecursively(node);
  }

  implicitHeight: rect.implicitHeight
  implicitWidth: rect.implicitWidth

  // Declared before the content so interactive children receive clicks first
  MouseArea {
    id: mouseArea

    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor

    onClicked: mouse => {
      if (mouse.button === Qt.RightButton) {
        root.rightClicked();
      } else if (mouse.button === Qt.MiddleButton) {
        root.middleClicked();
      } else {
        root.clicked();
      }
    }
  }

  My3dRectangle {
    id: rect

    anchors.fill: parent
    pressed: (mouseArea.pressed && mouseArea.pressedButtons & Qt.LeftButton)
             || root.forcePressed
  }
}
