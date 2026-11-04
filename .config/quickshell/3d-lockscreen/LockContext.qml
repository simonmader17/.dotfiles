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

    signal unlocked()
    signal failed()

    function tryUnlock() {
        if (currentText === "" || unlockInProgress)
            return ;

        unlockInProgress = true;
        message = "";
        pam.start();
    }

    // Typing after a failure clears it
    onCurrentTextChanged: {
        if (currentText !== "")
            showFailure = false;

    }

    PamContext {
        id: pam

        // Same stack as /etc/pam.d/hyprlock
        config: "login"
        onPamMessage: {
            if (responseRequired)
                respond(root.currentText);
            else if (message !== "")
                // e.g. faillock lockout notices
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
        }
        onError: (error) => {
            root.currentText = "";
            root.showFailure = true;
            root.message = "PAM error: " + PamError.toString(error);
            root.unlockInProgress = false;
            root.failed();
        }
    }

}
