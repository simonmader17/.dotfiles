// ToolTips.qml
pragma Singleton

import QtQuick
import Quickshell

// Keeps track of the tooltip that is currently shown. The actual drawing
// happens in My3dToolTipWindow, one per screen.
Singleton {
  id: root

  property var current: null
  // Tooltip waiting for the open delay to pass
  property var pending: null

  function hide(tip) {
    if (root.pending === tip) {
      showTimer.stop();
      root.pending = null;
    }
    if (root.current === tip) {
      hideTimer.restart();
    }
  }

  function show(tip) {
    hideTimer.stop();
    if (root.current !== null) {
      // A card is already out: slide it over right away
      showTimer.stop();
      root.pending = null;
      root.current = tip;
    } else {
      root.pending = tip;
      showTimer.restart();
    }
  }

  // Short delay before the first tooltip opens, so moving the mouse across
  // the bar doesn't flash tooltips open.
  Timer {
    id: showTimer

    interval: 250

    onTriggered: {
      root.current = root.pending;
      root.pending = null;
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
