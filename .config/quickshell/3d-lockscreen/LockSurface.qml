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
    MouseArea {
        anchors.fill: parent
        onClicked: passwordCard.focusInput()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24

        ClockCard {
            Layout.alignment: Qt.AlignHCenter
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
