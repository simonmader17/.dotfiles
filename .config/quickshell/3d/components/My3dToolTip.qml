// components/My3dToolTip.qml
import QtQuick
import Quickshell

import ".."

// Registers itself with the ToolTips singleton while visible. The tooltip is
// drawn by My3dToolTipWindow.
Scope {
  id: root

  property color baseColor: Pywal.background
  property int paddingX: 15
  property int paddingY: 8
  property bool visible: false
  required property Item anchorItem
  property string text: ""
  // Optional component drawn instead of the text
  property Component content: null
  // The card accepts input and stays open while hovered (e.g. for controls)
  property bool interactive: false
  readonly property bool active: visible && (text !== "" || content !== null)

  onActiveChanged: {
    if (active)
      ToolTips.show(root);
    else
      ToolTips.hide(root);
  }
  Component.onDestruction: ToolTips.hide(root)
}
