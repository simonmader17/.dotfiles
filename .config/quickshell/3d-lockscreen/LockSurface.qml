// LockSurface.qml
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import "components"
import "widgets"

Item {
    id: root

    required property LockContext context
    required property var screen
    readonly property string wallpaper: Pywal.wallpaper

    // Background: blurred wallpaper, or plain background color as fallback
    Rectangle {
        anchors.fill: parent
        color: Pywal.background
    }

    Image {
        id: wallpaperImage

        anchors.fill: parent
        visible: false
        source: root.wallpaper !== "" ? "file://" + root.wallpaper : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    MultiEffect {
        anchors.fill: parent
        visible: wallpaperImage.status === Image.Ready
        source: wallpaperImage
        blurEnabled: true
        blur: 1
        blurMax: 64
    }

    Rectangle {
        anchors.fill: parent
        color: Pywal.background
        opacity: 0.6
    }

    // Clicking anywhere gives the password field its focus back
    // Mouse movement and clicks also count as activity
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: root.context.poke()
        onPressed: root.context.poke()
        onClicked: passwordCard.focusInput()
    }

    // Rests above the password card; bounces around under it while idle
    BouncingClock {
        anchors.fill: parent
        moving: root.context.idle
        homeBottom: column.y - column.spacing
    }

    ColumnLayout {
        id: column

        anchors.centerIn: parent
        spacing: 24
        // Hidden while the clock bounces. Opacity (not visible) keeps the
        // input focused, so the first keystroke still lands and wakes it up.
        opacity: root.context.idle ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }

        }

        PasswordCard {
            id: passwordCard

            Layout.alignment: Qt.AlignHCenter
            context: root.context
        }

        // Failure / PAM message
        My3dRectangle {
            Layout.alignment: Qt.AlignHCenter
            opacity: root.context.message !== "" ? 1 : 0
            baseColor: Pywal.color1

            Text {
                font: Globals.myIconFont
                renderType: Globals.myIconFontRenderType
                text: "" // error
            }

            Text {
                font: Globals.myFont
                text: root.context.message
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }

            }

        }

    }

    // Status row
    RowLayout {
        spacing: 4
        // Hidden while the clock bounces, like the password column
        opacity: root.context.idle ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }

        }

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 16
        }

        My3dRectangle {
            baseColor: Pywal.color5

            Text {
                font: Globals.myFont
                text: Quickshell.env("USER") ?? ""
            }

            Text {
                font: Globals.myIconFont
                renderType: Globals.myIconFontRenderType
                text: "" // person
            }

        }

        BatteryCard {
        }

    }

}
