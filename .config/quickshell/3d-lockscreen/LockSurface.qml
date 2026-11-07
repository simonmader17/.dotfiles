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
    // Load before the first frame so the wallpaper is there when the
    // surface slides in (asynchronous loading would pop it in later)
    asynchronous: false
    fillMode: Image.PreserveAspectCrop
    source: root.wallpaper !== "" ? "file://" + root.wallpaper : ""
    visible: false
  }

  MultiEffect {
    anchors.fill: parent
    blur: 1
    blurEnabled: true
    blurMax: 64
    source: wallpaperImage
    visible: wallpaperImage.status === Image.Ready
  }

  Rectangle {
    anchors.fill: parent
    color: Pywal.background
    opacity: 0.6
  }

  // Rests above the password card; bounces around under it while idle
  BouncingClock {
    anchors.fill: parent
    homeBottom: column.y - column.spacing
    moving: root.context.idle
  }

  ColumnLayout {
    id: column

    anchors.centerIn: parent
    // Hidden while the clock bounces. Opacity (not visible) keeps the
    // input focused, so the first keystroke still lands and wakes it up.
    opacity: root.context.idle ? 0 : 1
    spacing: 24

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
      baseColor: Pywal.color1
      opacity: root.context.message !== "" ? 1 : 0

      Behavior on opacity {
        NumberAnimation {
          duration: 150
        }
      }

      Text {
        font: Globals.myIconFont
        renderType: Globals.myIconFontRenderType
        text: "\ue000" // error
      }

      Text {
        font: Globals.myFont
        text: root.context.message
      }
    }
  }

  // Status row
  RowLayout {
    // Hidden while the clock bounces, like the password column
    opacity: root.context.idle ? 0 : 1
    spacing: 4

    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    anchors {
      bottom: parent.bottom
      margins: 16
      right: parent.right
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
        text: "\ue7fd" // person
      }
    }

    BatteryCard {
    }
  }
}
