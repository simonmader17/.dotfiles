// shell.qml
//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Wayland
import "processes"

ShellRoot {
    id: root

    // QS_LOCK_TEST=1 shows the lockscreen in normal windows without locking
    readonly property bool testMode: Quickshell.env("QS_LOCK_TEST") === "1"

    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false;
            Qt.quit();
        }
    }

    WlSessionLock {
        id: lock

        locked: !root.testMode

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

    Variants {
        model: root.testMode ? Quickshell.screens : []

        FloatingWindow {
            id: window

            required property var modelData

            screen: modelData
            color: Pywal.background
            implicitWidth: 1280
            implicitHeight: 800

            LockSurface {
                anchors.fill: parent
                context: lockContext
                screen: window.modelData
            }

        }

    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: BatteryProc.running = true
    }

}
