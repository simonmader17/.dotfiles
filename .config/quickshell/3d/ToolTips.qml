// ToolTips.qml
pragma Singleton

import QtQuick
import Quickshell

// Keeps track of the tooltip that is currently shown. The actual drawing
// happens in My3dToolTipWindow, one per screen.
Singleton {
  id: root

  property var current: null

  function show(tip) {
    hideTimer.stop();
    root.current = tip;
  }

  function hide(tip) {
    if (root.current === tip) {
      hideTimer.restart();
    }
  }

  // Short delay so moving between two icons slides the tooltip over instead
  // of closing and reopening it.
  Timer {
    id: hideTimer
    interval: 250
    onTriggered: root.current = null
  }
}
