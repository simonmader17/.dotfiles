import ".."
import "../components"
// widgets/PasswordCard.qml
import QtQuick
import QtQuick.Layouts

My3dRectangle {
    id: root

    required property LockContext context

    function focusInput() {
        input.forceActiveFocus();
    }

    baseColor: context.showFailure ? Pywal.color1 : Pywal.color4
    depth: 6
    paddingX: 20
    paddingY: 12

    // Briefly press the card down on every keystroke
    Timer {
        id: keyPressTimer

        interval: 80
        onTriggered: root.pressed = false
    }

    SequentialAnimation {
        id: shakeAnimation

        loops: 2

        NumberAnimation {
            target: shakeOffset
            property: "x"
            to: -12
            duration: 40
        }

        NumberAnimation {
            target: shakeOffset
            property: "x"
            to: 12
            duration: 80
        }

        NumberAnimation {
            target: shakeOffset
            property: "x"
            to: 0
            duration: 40
        }

    }

    Connections {
        function onFailed() {
            shakeAnimation.restart();
        }

        // Keeps the fields of all screens in sync
        function onCurrentTextChanged() {
            if (input.text !== root.context.currentText)
                input.text = root.context.currentText;

        }

        target: root.context
    }

    Text {
        // hourglass

        font: Globals.myIconFont
        renderType: Globals.myIconFontRenderType
        text: root.context.unlockInProgress ? "" : "" // lock
    }

    Item {
        implicitWidth: 300
        implicitHeight: input.implicitHeight

        TextInput {
            id: input

            anchors.fill: parent
            focus: true
            enabled: !root.context.unlockInProgress
            font: Globals.myFont
            echoMode: TextInput.Password
            passwordCharacter: "●"
            clip: true
            verticalAlignment: TextInput.AlignVCenter
            Component.onCompleted: forceActiveFocus()
            onTextChanged: {
                root.context.currentText = text;
                if (text !== "") {
                    root.pressed = true;
                    keyPressTimer.restart();
                }
            }
            onAccepted: root.context.tryUnlock()
            Keys.onEscapePressed: text = ""
            // Any key counts as activity, even ones that don't change the text
            Keys.onPressed: (event) => {
                root.context.poke();
                event.accepted = false;
            }
        }

        Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            visible: input.text === ""
            opacity: 0.6
            font: Globals.myFont
            text: root.context.unlockInProgress ? "Checking…" : "Password"
        }

    }

    Behavior on baseColor {
        ColorAnimation {
            duration: 150
        }

    }

    transform: Translate {
        id: shakeOffset
    }

}
