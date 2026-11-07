// components/MediaPopup.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

import ".."
import "../helper.js" as Helper

// Tooltip content for MediaWidget: the current track, a seekable progress bar,
// playback controls and a switcher between MPRIS players.
ColumnLayout {
  id: root

  required property var player
  property color baseColor: Pywal.color4

  readonly property color textColor: Helper.contrastColor(baseColor, Pywal.background, Pywal.foreground)
  property color buttonColor: Qt.lighter(baseColor, 1.5)
  readonly property bool hasLength: (root.player?.lengthSupported ?? false) && root.player.length > 0

  signal switchPlayer()

  function formatTime(seconds) {
    const s = Math.max(0, Math.floor(seconds));
    const m = Math.floor(s / 60);
    return m + ":" + String(s % 60).padStart(2, "0");
  }

  spacing: 8

  // MPRIS doesn't push position updates, so refresh it while playing
  Timer {
    interval: 1000
    repeat: true
    running: root.player?.isPlaying ?? false
    onTriggered: root.player.positionChanged()
  }

  // Track info
  RowLayout {
    spacing: 10

    Image {
      // Fixed height, width from the aspect ratio, so the art isn't cropped
      Layout.preferredWidth: implicitHeight > 0 ? 80 * implicitWidth / implicitHeight : 80
      Layout.preferredHeight: 80
      visible: source.toString() !== ""
      source: root.player?.trackArtUrl ?? ""
      sourceSize.height: 160
      fillMode: Image.PreserveAspectFit
      asynchronous: true
    }

    ColumnLayout {
      Layout.preferredWidth: 230
      spacing: 2

      Text {
        readonly property bool colorSet: true

        Layout.fillWidth: true
        color: root.textColor
        elide: Text.ElideRight
        font.family: Globals.myFont.family
        font.pointSize: Globals.myFont.pointSize
        font.bold: true
        text: root.player?.trackTitle || "Unknown title"
      }

      Text {
        readonly property bool colorSet: true

        Layout.fillWidth: true
        visible: text !== ""
        color: root.textColor
        elide: Text.ElideRight
        font: Globals.myFont
        text: root.player?.trackArtist ?? ""
      }

      Text {
        readonly property bool colorSet: true

        Layout.fillWidth: true
        visible: text !== ""
        color: root.textColor
        opacity: 0.7
        elide: Text.ElideRight
        font: Globals.myFont
        text: root.player?.trackAlbum ?? ""
      }
    }
  }

  // Progress
  ColumnLayout {
    Layout.fillWidth: true
    visible: root.hasLength
    spacing: 2

    Item {
      Layout.fillWidth: true
      implicitHeight: 12

      Rectangle {
        id: track

        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: 3
        color: Qt.lighter(root.baseColor, 1.8)

        Rectangle {
          width: root.hasLength ? Math.min(1, root.player.position / root.player.length) * parent.width : 0
          height: parent.height
          radius: parent.radius
          color: root.textColor
        }
      }

      MouseArea {
        anchors.fill: parent
        enabled: root.player?.canSeek ?? false
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
          root.player.position = Math.max(0, Math.min(1, mouse.x / width)) * root.player.length;
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true

      Text {
        readonly property bool colorSet: true

        color: root.textColor
        font: Globals.myFont
        text: root.formatTime(root.player?.position ?? 0)
      }

      Item {
        Layout.fillWidth: true
      }

      Text {
        readonly property bool colorSet: true

        color: root.textColor
        font: Globals.myFont
        text: root.formatTime(root.player?.length ?? 0)
      }
    }
  }

  // Controls
  RowLayout {
    Layout.fillWidth: true
    spacing: 6

    My3dButton {
      enabled: root.player?.canGoPrevious ?? false
      opacity: enabled ? 1 : 0.5
      // Flat while disabled
      forcePressed: !enabled
      baseColor: root.buttonColor
      onClicked: root.player.previous()

      Text {
        font: Globals.myIconFont
        renderType: Globals.myIconFontRenderType
        text: "" // skip_previous
      }
    }

    My3dButton {
      enabled: root.player?.canTogglePlaying ?? false
      opacity: enabled ? 1 : 0.5
      // Flat while disabled
      forcePressed: !enabled
      baseColor: root.buttonColor
      onClicked: root.player.togglePlaying()

      Text {
        font: Globals.myIconFont
        renderType: Globals.myIconFontRenderType
        text: root.player?.isPlaying ? "" : "" // pause / play_arrow
      }
    }

    My3dButton {
      enabled: root.player?.canGoNext ?? false
      opacity: enabled ? 1 : 0.5
      // Flat while disabled
      forcePressed: !enabled
      baseColor: root.buttonColor
      onClicked: root.player.next()

      Text {
        font: Globals.myIconFont
        renderType: Globals.myIconFontRenderType
        text: "" // skip_next
      }
    }

    Item {
      Layout.fillWidth: true
    }

    // Player switcher
    My3dButton {
      visible: Mpris.players.values.length > 1
      baseColor: root.buttonColor
      onClicked: root.switchPlayer()

      RowLayout {
        Text {
          Layout.maximumWidth: 120
          elide: Text.ElideRight
          font: Globals.myFont
          text: root.player?.identity ?? ""
        }

        Text {
          font: Globals.myIconFont
          renderType: Globals.myIconFontRenderType
          text: "" // chevron_right
        }
      }
    }
  }
}
