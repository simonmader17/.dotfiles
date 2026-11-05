// shell.qml
//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Wayland
import "processes"

ShellRoot {
  id: root

  // True once the compositor confirms the lock covers every screen; the
  // slide overlays stay up until then so there's no gap in between
  property bool overlaysDone: false
  // 0 → 1: how far the lockscreen has slid down from the top
  property real slide: slideIn ? 0 : 1
  property bool slideDone: !slideIn
  // QS_LOCK_ANIMATE=1 (lock.sh --animate): the lockscreen first slides down
  // over the real desktop in overlay windows, and only then does the session
  // lock engage. The session is NOT locked during that slide. Without it,
  // the session locks at once (hypridle, before suspend).
  readonly property bool slideIn: Quickshell.env("QS_LOCK_ANIMATE") === "1"

  // QS_LOCK_TEST=1 shows the lockscreen in normal windows without locking
  readonly property bool testMode: Quickshell.env("QS_LOCK_TEST") === "1"

  Component.onCompleted: {
    if (slideIn)
      slideAnim.start();
  }

  NumberAnimation {
    id: slideAnim

    duration: 450
    easing.type: Easing.OutCubic
    from: 0
    property: "slide"
    target: root
    to: 1

    onFinished: root.slideDone = true
  }

  LockContext {
    id: lockContext

    onUnlocked: {
      lock.locked = false;
      Qt.quit();
    }
  }

  WlSessionLock {
    id: lock

    locked: !root.testMode && root.slideDone

    onSecureChanged: {
      if (secure)
        root.overlaysDone = true;
    }

    WlSessionLockSurface {
      id: surface

      color: Pywal.background

      LockSurface {
        anchors.fill: parent
        context: lockContext
        screen: surface.screen
      }
    }
  }

  // Slide-in overlays above everything on the real desktop
  Variants {
    model: !root.testMode && root.slideIn && !root.overlaysDone
           ? Quickshell.screens : []

    PanelWindow {
      id: overlay

      required property var modelData

      // Typing during the slide already goes into the password field
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "3d-lockscreen"
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      screen: modelData

      anchors {
        bottom: true
        left: true
        right: true
        top: true
      }

      LockSurface {
        context: lockContext
        height: parent.height
        screen: overlay.modelData
        width: parent.width
        y: -(1 - root.slide) * height
      }
    }
  }

  Variants {
    model: root.testMode ? Quickshell.screens : []

    FloatingWindow {
      id: window

      required property var modelData

      color: "transparent"
      implicitHeight: 800
      implicitWidth: 1280
      screen: modelData

      // Plays the slide inside the window
      LockSurface {
        context: lockContext
        height: parent.height
        screen: window.modelData
        width: parent.width
        y: -(1 - root.slide) * height
      }
    }
  }

  Timer {
    interval: 10000
    repeat: true
    running: true
    triggeredOnStart: true

    onTriggered: BatteryProc.running = true
  }
}
