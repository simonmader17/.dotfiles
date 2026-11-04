// components/WorkspacePreview.qml
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

import ".."
import "../processes"

// Live miniature of a Hyprland workspace, built from one screencopy per window
Item {
  id: root

  required property HyprlandWorkspace ws
  property real scaleFactor: 0.2
  // Multiplier on the estimated Hyprland blur radius, to tune the preview's
  // blur against the real one by eye
  property real blurStrength: 3
  property color frameColor: Pywal.color1
  // Width of the bezel around the screen, thicker at the top for the depth
  property int bezel: 1
  property int bezelTop: 3

  readonly property HyprlandMonitor mon: ws.monitor
  // Space taken by the bars (exclusive zones) as [left, top, right, bottom]
  readonly property var reserved: mon?.lastIpcObject?.reserved ?? [0, 0, 0, 0]

  function screenFor(monitor) {
    if (!monitor) {
      return null;
    }
    for (const screen of Quickshell.screens) {
      if (screen.name === monitor.name) {
        return screen;
      }
    }
    return null;
  }

  implicitWidth: (mon ? mon.width / mon.scale * scaleFactor : 0) + 2 * bezel
  implicitHeight: (mon ? mon.height / mon.scale * scaleFactor : 0) + bezelTop + bezel

  // Window and monitor data in lastIpcObject is not updated by events, so
  // they are refreshed when the preview opens
  Component.onCompleted: {
    Hyprland.refreshMonitors();
    Hyprland.refreshToplevels();
    HyprOptionsProc.running = true;
  }

  // Hyprland sends no events for moving or resizing windows, or for options
  // changed at runtime (e.g. toggling blur), so both are polled while the
  // preview is open
  Timer {
    interval: 100
    running: true
    repeat: true
    onTriggered: {
      Hyprland.refreshToplevels();
      HyprOptionsProc.running = true;
    }
  }

  // Bezel, darkened like My3dRectangle's depth layer so the screen looks sunk
  // into the frame
  Rectangle {
    anchors.fill: parent
    color: Qt.darker(root.frameColor, 1.4)
    radius: 5
  }

  // Screen
  Rectangle {
    anchors.fill: parent
    anchors.margins: root.bezel
    anchors.topMargin: root.bezelTop
    color: Pywal.background
    radius: 4
    clip: true

    Image {
      id: wallpaper

      readonly property string path: Pywal.wallpaper

      anchors.fill: parent
      visible: status === Image.Ready
      source: path !== "" ? "file://" + path : ""
      fillMode: Image.PreserveAspectCrop
      sourceSize: Qt.size(width, height)
      asynchronous: true
    }

    // Window captures don't include Hyprland's blur, so translucent windows
    // show this blurred wallpaper behind them instead. Only the windows'
    // ShaderEffectSources show it, they hide the item itself.
    MultiEffect {
      id: blurredWallpaper

      anchors.fill: wallpaper
      source: wallpaper
      // Without windows nothing would hide it
      visible: HyprOptionsProc.blur && wallpaper.visible && root.ws.toplevels.values.length > 0
      autoPaddingEnabled: false
      blurEnabled: true
      blur: 1
      // Estimate of Hyprland's visible blur radius in preview pixels: its
      // dual-Kawase blur spreads about size * 2^passes pixels, and MultiEffect
      // only reaches about a third of blurMax
      blurMax: Math.max(1, Math.round(1.5 * HyprOptionsProc.blurSize * Math.pow(2, HyprOptionsProc.blurPasses) * root.scaleFactor * root.blurStrength))
    }

    Text {
      anchors.centerIn: parent
      visible: root.ws.toplevels.values.length === 0
      color: Pywal.foreground
      style: Text.Outline
      styleColor: Pywal.background
      font: Globals.myFont
      text: "empty"
    }

    Repeater {
      model: root.ws.toplevels.values

      Item {
        id: win

        required property HyprlandToplevel modelData
        readonly property var ipc: modelData.lastIpcObject ?? {}
        // at and size exclude the border, which Hyprland draws around the
        // window, so without it the preview shows gaps where the borders are
        readonly property int border: ipc.fullscreen ? 0 : HyprOptionsProc.borderSize
        // Border box in screen coordinates as [left, top, right, bottom]
        readonly property var box: visible ? [ipc.at[0] - root.mon.x - border, ipc.at[1] - root.mon.y - border, ipc.at[0] - root.mon.x + ipc.size[0] + border, ipc.at[1] - root.mon.y + ipc.size[1] + border] : [0, 0, 0, 0]
        // Edges are rounded rather than sizes, so neighbouring windows share
        // a pixel edge instead of leaving an anti-aliased seam
        readonly property var edges: box.map(v => Math.round(v * root.scaleFactor))

        visible: ipc.at !== undefined && ipc.size !== undefined
        x: edges[0]
        y: edges[1]
        width: edges[2] - edges[0]
        height: edges[3] - edges[1]
        z: ipc.floating ? 1 : 0

        // Smooth the steps between geometry polls, but don't animate in from
        // 0 when the first geometry of a new window arrives
        property bool placed: false
        onVisibleChanged: if (visible) Qt.callLater(() => win.placed = true)
        Component.onCompleted: if (visible) placed = true

        Behavior on x { enabled: win.placed && HyprOptionsProc.animations; NumberAnimation { duration: 100 } }
        Behavior on y { enabled: win.placed && HyprOptionsProc.animations; NumberAnimation { duration: 100 } }
        Behavior on width { enabled: win.placed && HyprOptionsProc.animations; NumberAnimation { duration: 100 } }
        Behavior on height { enabled: win.placed && HyprOptionsProc.animations; NumberAnimation { duration: 100 } }

        // Blur behind the window, cut out of the blurred wallpaper
        ShaderEffectSource {
          anchors.fill: parent
          visible: blurredWallpaper.visible
          sourceItem: blurredWallpaper
          hideSource: true
          sourceRect: Qt.rect(win.x, win.y, win.width, win.height)
        }

        ScreencopyView {
          id: screencopy

          anchors.fill: parent
          captureSource: win.modelData.wayland
          live: true
          // The capture keeps the alpha of translucent windows, but its
          // texture is marked opaque, so Qt draws it without blending and the
          // alpha punches through the tooltip window to the real desktop. A
          // layer texture has alpha and is blended over the wallpaper.
          layer.enabled: true
        }

        // Fallback while there is no frame yet
        IconImage {
          anchors.centerIn: parent
          visible: !screencopy.hasContent
          implicitSize: Math.min(parent.width, parent.height) / 2
          source: Quickshell.iconPath(Globals.guessIcon(win.modelData.wayland?.appId), true)
        }

        Rectangle {
          anchors.fill: parent
          color: "transparent"
          border.width: 1
          border.color: win.modelData.activated ? Pywal.color1 : Qt.darker(Pywal.foreground, 2)
          radius: 2
        }
      }
    }

    // The bars are layer surfaces, not toplevels, and look the same on every
    // workspace, so they are cut out of a capture of the whole monitor. Only
    // the strips below show it, the rest of the capture is hidden.
    ScreencopyView {
      id: screenCapture

      anchors.fill: parent
      // Without strips nothing would hide the capture
      captureSource: strips.count > 0 ? root.screenFor(root.mon) : null
      live: true
    }

    Repeater {
      id: strips

      // One strip per side of the reserved area, in screen coordinates
      model: {
        const w = root.mon ? root.mon.width / root.mon.scale : 0;
        const h = root.mon ? root.mon.height / root.mon.scale : 0;
        const [l, t, r, b] = root.reserved;
        return [Qt.rect(0, 0, l, h), Qt.rect(0, 0, w, t), Qt.rect(w - r, 0, r, h), Qt.rect(0, h - b, w, b)].filter(strip => strip.width > 0 && strip.height > 0);
      }

      ShaderEffectSource {
        required property rect modelData

        x: modelData.x * root.scaleFactor
        y: modelData.y * root.scaleFactor
        width: modelData.width * root.scaleFactor
        height: modelData.height * root.scaleFactor
        z: 2
        sourceItem: screenCapture
        hideSource: true
        sourceRect: Qt.rect(x, y, width, height)
      }
    }
  }
}
