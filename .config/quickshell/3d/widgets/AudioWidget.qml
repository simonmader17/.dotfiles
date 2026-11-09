// widgets/AudioWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../components"
import "../helper.js" as Helper

import ".."

My3dRectangle {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource

  PwObjectTracker {
    objects: [root.sink, root.source]
  }

  RowLayout {
    // Speaker
    Item {
      implicitHeight: rowLayoutSink.implicitHeight
      implicitWidth: rowLayoutSink.implicitWidth

      RowLayout {
        id: rowLayoutSink

        Text {
          font: Globals.myFont
          text: Math.round(root.sink?.audio.volume * 100 || 0) + "%"
          visible: !root.sink?.audio.muted
        }

        Text {
          font: Globals.myIconFont
          renderType: Globals.myIconFontRenderType
          text: {
            if (!root.sink) {
              return "\uf4f3"; // media-output-off
            }
            if (root.sink.audio.muted) {
              return "\ue04f"; // volume-off
            }
            return Helper.chooseIconBasedOnPercentage(["\ue04e" // volume-mute
                                                       , "\ue04d" // volume-down
                                                       , "\ue050", // volume-up
                                                      ], root.sink
                                                      ?.audio.volume || 0);
          }
        }

        HoverHandler {
          id: hoverHandlerSink
        }

        My3dToolTip {
          id: tipSink

          anchorItem: rowLayoutSink
          baseColor: Qt.darker(root.baseColor, 2)
          interactive: true
          visible: hoverHandlerSink.hovered

          content: Component {
            AudioDevicePopup {
              baseColor: tipSink.baseColor
              buttonColor: root.baseColor
              sink: true
            }
          }
        }
      }

      MouseArea {
        anchors.fill: parent

        onClicked: {
          if (root.sink) {
            root.sink.audio.muted = !root.sink.audio.muted;
          }
        }
        onWheel: event => {
          if (root.sink) {
            root.sink.audio.volume = Math.min(1, root.sink.audio.volume + (
                                                event.angleDelta.y / 120)
                                              * 0.05);
          }
        }
      }
    }

    // Microphone
    Item {
      implicitHeight: rowLayoutSource.implicitHeight
      implicitWidth: rowLayoutSource.implicitWidth

      RowLayout {
        id: rowLayoutSource

        Text {
          font: Globals.myFont
          text: Math.round(root.source?.audio.volume * 100 || 0) + "%"
          visible: !root.source?.audio.muted
        }

        Text {
          font: Globals.myIconFont
          renderType: Globals.myIconFontRenderType
          text: {
            if (!root.source) {
              return "\uf392"; // mic-alert
            }
            if (root.source.audio.muted) {
              return "\ue02b"; // mic-off
            }
            return "\ue029"; // mic
          }
        }

        HoverHandler {
          id: hoverHandlerSource
        }

        My3dToolTip {
          id: tipSource

          anchorItem: rowLayoutSource
          baseColor: Qt.darker(root.baseColor, 2)
          interactive: true
          visible: hoverHandlerSource.hovered

          content: Component {
            AudioDevicePopup {
              baseColor: tipSource.baseColor
              buttonColor: root.baseColor
              sink: false
            }
          }
        }
      }

      MouseArea {
        anchors.fill: parent

        onClicked: {
          if (root.source) {
            root.source.audio.muted = !root.source.audio.muted;
          }
        }
        onWheel: event => {
          if (root.source) {
            root.source.audio.volume = Math.min(1, root.source.audio.volume + (
                                                  event.angleDelta.y / 120)
                                                * 0.05);
          }
        }
      }
    }
  }
}
