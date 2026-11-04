// components/My3dToolTipWindow.qml
import QtQuick
import Quickshell

import ".."
import "../components"

// Transparent, click-through overlay next to the bar that draws the active
// tooltip, so it can pop out of the bar and slide between icons. Cards come
// out below a horizontal bar, or to the right of a vertical one.
PanelWindow {
  id: root

  required property PanelWindow bar
  property bool vertical: false
  // Space at the top of a vertical overlay that cards must not cover
  property real topOffset: 0

  // The tooltip belonging to this screen's bar, if any
  readonly property var tip: ToolTips.current && ToolTips.current.anchorItem.QsWindow.window === root.bar ? ToolTips.current : null
  // The last shown tooltip, kept while the card retracts
  property var shownTip: null

  onTipChanged: {
    if (tip) {
      shownTip = tip;
    }
  }

  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  implicitHeight: vertical ? 0 : bar.height + card.implicitHeight + 16
  implicitWidth: vertical ? bar.width + card.implicitWidth + 16 : 0
  anchors {
    top: true
    left: true
    right: !root.vertical
    bottom: root.vertical
  }
  mask: Region {}

  // Only draw outside the bar, so the card looks like it comes out from behind it
  Item {
    id: clipArea

    x: root.vertical ? root.bar.width : 0
    y: root.vertical ? root.topOffset : root.bar.height
    width: parent.width - x
    height: parent.height - y
    clip: true

    My3dRectangle {
      id: card

      readonly property point anchorPos: root.shownTip ? root.shownTip.anchorItem.mapToItem(null, 0, 0) : Qt.point(0, 0)
      readonly property bool onScreen: root.vertical ? x > -width : y > -height

      baseColor: root.shownTip ? root.shownTip.baseColor : Pywal.background
      paddingX: root.shownTip ? root.shownTip.paddingX : 15
      paddingY: root.shownTip ? root.shownTip.paddingY : 8
      x: root.vertical
        ? (root.tip ? 4 : -width - 4)
        : Math.max(4, Math.min(anchorPos.x, clipArea.width - implicitWidth - 4))
      y: root.vertical
        ? Math.max(4, Math.min(anchorPos.y - clipArea.y, clipArea.height - implicitHeight - 4))
        : (root.tip ? 4 : -height - 4)
      width: implicitWidth
      height: implicitHeight

      // The sliding axis pops out, the other one follows the anchor
      Behavior on y {
        enabled: !root.vertical || card.onScreen
        NumberAnimation {
          duration: root.vertical ? 180 : 220
          easing.type: root.vertical ? Easing.OutCubic : (root.tip ? Easing.OutBack : Easing.InCubic)
        }
      }
      Behavior on x {
        enabled: root.vertical || card.onScreen
        NumberAnimation {
          duration: root.vertical ? 220 : 180
          easing.type: !root.vertical ? Easing.OutCubic : (root.tip ? Easing.OutBack : Easing.InCubic)
        }
      }
      Behavior on width {
        enabled: card.onScreen
        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
      }
      Behavior on height {
        enabled: card.onScreen
        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
      }
      Behavior on baseColor {
        enabled: card.onScreen
        ColorAnimation { duration: 180 }
      }

      Text {
        visible: !contentLoader.visible
        text: root.shownTip ? root.shownTip.text : ""
        font: Globals.myFont
      }

      // Custom content, kept loaded until the card has retracted
      Loader {
        id: contentLoader

        visible: active
        active: !!root.shownTip?.content && (!!root.tip || card.onScreen)
        sourceComponent: root.shownTip?.content ?? null
      }
    }
  }
}
