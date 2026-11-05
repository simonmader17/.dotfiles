// LockContext.qml
import QtQuick
import Quickshell
import Quickshell.Services.Pam

// State shared by the lock surfaces of all screens
Scope {
    id: root

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    property string message: ""
    // Becomes true after 3 s without input; drives the bouncing clock
    property bool idle: false

    signal unlocked()
    signal failed()

    // Call on any user input to reset the idle countdown
    function poke() {
        idle = false;
        idleTimer.restart();
    }

    function tryUnlock() {
        if (currentText === "" || unlockInProgress)
            return ;

        unlockInProgress = true;
        message = "";
        pam.start();
    }

    // Typing after a failure clears it
    onCurrentTextChanged: {
        poke();
        if (currentText !== "")
            showFailure = false;

    }

    Timer {
        id: idleTimer

        interval: 3000
        running: true
        onTriggered: root.idle = true
    }

    PamContext {
        id: pam

        // Same stack as /etc/pam.d/hyprlock
        config: "login"
        onPamMessage: {
            // e.g. faillock lockout notices

            if (responseRequired)
                respond(root.currentText);
            else if (message !== "")
                root.message = message;
        }
        onCompleted: (result) => {
            if (result === PamResult.Success) {
                root.unlocked();
            } else {
                root.currentText = "";
                root.showFailure = true;
                if (root.message === "")
                    root.message = "Wrong password";

                root.failed();
            }
            root.unlockInProgress = false;
            root.poke();
        }
        onError: (error) => {
            root.currentText = "";
            root.showFailure = true;
            root.message = "PAM error: " + PamError.toString(error);
            root.unlockInProgress = false;
            root.poke();
            root.failed();
        }
    }

}
