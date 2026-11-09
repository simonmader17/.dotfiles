// components/AudioDevicePopup.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../helper.js" as Helper

import ".."

// Tooltip content for AudioWidget: the current default device and a list of
// all output (sink) or input (source) devices to switch to.
ColumnLayout {
  id: root

  property color baseColor: Pywal.color4
  property color buttonColor: Qt.lighter(baseColor, 1.5)
  readonly property var current: sink ? Pipewire.defaultAudioSink :
                                        Pipewire.defaultAudioSource
  readonly property var devices: Pipewire.nodes.values.filter(n => n.audio &&
                                                                   !n.isStream
                                                                   && n.isSink
                                                                   === root.sink)

  // true lists outputs, false lists inputs
  required property bool sink
  readonly property color textColor: Helper.contrastColor(baseColor,
                                                          Pywal.background,
                                                          Pywal.foreground)

  // Material Symbols icon for the kind of device, guessed from its name
  function deviceIcon(node) {
    const s = ((node?.name ?? "") + " " + (node?.description ?? "")).toLowerCase(
            );
    if (s.includes("headset")) {
      return ""; // headset_mic
    }
    if (s.includes("headphone")) {
      return ""; // headphones
    }
    if (s.includes("bluez") || s.includes("bluetooth")) {
      return root.sink ? "" : ""; // headphones / headset_mic
    }
    if (s.includes("hdmi") || s.includes("displayport")) {
      return ""; // tv
    }
    // Audio interfaces, by brand or model name
    const interfaces = ["umc", "behringer", "focusrite", "scarlett", "motu",
                        "audient", "presonus", "steinberg", "universal_audio",
                        "babyface", "tascam", "komplete", "arturia", "minifuse",
                        "m-audio", "apogee"];
    if (interfaces.some(i => s.includes(i))) {
      return "\ue026"; // instant_mix
    }
    if (s.includes("usb")) {
      return ""; // usb
    }
    return root.sink ? "" : ""; // speaker / mic
  }

  function deviceName(node) {
    return node?.description || node?.nickname || node?.name || "";
  }

  spacing: 6

  Text {
    readonly property bool colorSet: true

    color: root.textColor
    font.bold: true
    font.family: Globals.myFont.family
    font.pointSize: Globals.myFont.pointSize
    text: root.sink ? "Output" : "Input"
  }

  Text {
    readonly property bool colorSet: true

    Layout.maximumWidth: 340
    color: root.textColor
    elide: Text.ElideRight
    font: Globals.myFont
    opacity: 0.7
    text: root.current?.name ?? ""
    visible: !!root.current
  }

  // Volume of the current device
  RowLayout {
    Layout.fillWidth: true
    spacing: 8
    visible: !!root.current?.audio

    My3dButton {
      baseColor: root.buttonColor

      onClicked: root.current.audio.muted = !root.current.audio.muted

      Text {
        font: Globals.myIconFont
        renderType: Globals.myIconFontRenderType
        text: {
          if (root.current?.audio.muted) {
            return root.sink ? "" : ""; // volume-off / mic-off
          }
          return root.sink ? "" : ""; // volume-up / mic
        }
      }
    }

    Item {
      Layout.fillWidth: true
      implicitHeight: 16

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        color: Qt.lighter(root.baseColor, 1.8)
        height: 6
        radius: 3
        width: parent.width

        Rectangle {
          color: root.textColor
          height: parent.height
          opacity: root.current?.audio.muted ? 0.4 : 1
          radius: parent.radius
          width: Math.min(1, root.current?.audio.volume ?? 0) * parent.width
        }
      }

      MouseArea {
        function setVolume(x) {
          root.current.audio.volume = Math.max(0, Math.min(1, x / width));
        }

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onPositionChanged: mouse => {
          if (pressed) {
            setVolume(mouse.x);
          }
        }
        onPressed: mouse => setVolume(mouse.x)
        onWheel: wheel => {
          const v = root.current.audio.volume + (wheel.angleDelta.y / 120)
                * 0.05;
          root.current.audio.volume = Math.max(0, Math.min(1, v));
        }
      }
    }

    Text {
      readonly property bool colorSet: true

      Layout.minimumWidth: 40
      color: root.textColor
      font: Globals.myFont
      horizontalAlignment: Text.AlignRight
      text: Math.round((root.current?.audio.volume ?? 0) * 100) + "%"
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 2

    Repeater {
      model: root.devices

      Item {
        id: deviceRow

        readonly property bool active: modelData === root.current
        required property var modelData

        Layout.fillWidth: true
        implicitHeight: row.implicitHeight + 12
        implicitWidth: row.implicitWidth + 20

        // Background: filled for the active device, subtle on hover
        Rectangle {
          anchors.fill: parent
          color: deviceRow.active ? Qt.lighter(root.baseColor, 1.6) :
                                    hover.hovered ? Qt.lighter(root.baseColor,
                                                               1.3) : "transparent"
          radius: 6

          Behavior on color {
            ColorAnimation {
              duration: 120
            }
          }
        }

        // Accent bar
        Rectangle {
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.margins: 4
          anchors.top: parent.top
          color: root.textColor
          radius: 1.5
          visible: deviceRow.active
          width: 3
        }

        RowLayout {
          id: row

          anchors.left: parent.left
          anchors.leftMargin: 12
          anchors.right: parent.right
          anchors.rightMargin: 8
          anchors.verticalCenter: parent.verticalCenter
          spacing: 8

          Text {
            readonly property bool colorSet: true

            color: root.textColor
            font: Globals.myIconFont
            opacity: deviceRow.active ? 1 : 0.75
            renderType: Globals.myIconFontRenderType
            text: root.deviceIcon(deviceRow.modelData)
          }

          Text {
            readonly property bool colorSet: true

            Layout.fillWidth: true
            Layout.maximumWidth: 300
            color: root.textColor
            elide: Text.ElideRight
            font.bold: deviceRow.active
            font.family: Globals.myFont.family
            font.pointSize: Globals.myFont.pointSize
            opacity: deviceRow.active ? 1 : 0.75
            text: root.deviceName(deviceRow.modelData)
          }
        }

        HoverHandler {
          id: hover
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor

          onClicked: {
            if (root.sink) {
              Pipewire.preferredDefaultAudioSink = deviceRow.modelData;
            } else {
              Pipewire.preferredDefaultAudioSource = deviceRow.modelData;
            }
          }
        }
      }
    }
  }
}
