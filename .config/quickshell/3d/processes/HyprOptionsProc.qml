// processes/HyprOptionsProc.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
  id: root

  property alias running: hyprOptionsProc.running

  property bool valid: false
  // Hyprland's animations:enabled
  property bool animations: false
  // Hyprland's general:border_size
  property int borderSize: 0
  // Hyprland's decoration:blur:enabled, size and passes
  property bool blur: false
  property int blurSize: 0
  property int blurPasses: 0

  Component.onCompleted: hyprOptionsProc.running = true

  // Pick up config edits and `hyprctl reload`
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name === "configreloaded") {
        hyprOptionsProc.running = true;
      }
    }
  }

  Process {
    id: hyprOptionsProc
    command: [Quickshell.shellDir + "/scripts/hypr-options.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        const fields = text.trim().split(";");
        if (fields.length === 5) {
          root.animations = fields[0] === "1";
          root.borderSize = parseInt(fields[1]);
          root.blur = fields[2] === "1";
          root.blurSize = parseInt(fields[3]);
          root.blurPasses = parseInt(fields[4]);
          root.valid = true;
        } else {
          root.animations = false;
          root.borderSize = 0;
          root.blur = false;
          root.blurSize = 0;
          root.blurPasses = 0;
          root.valid = false;
        }
      }
    }
  }
}
