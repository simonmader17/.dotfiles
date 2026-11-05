import ".."
// widgets/BouncingClock.qml
// The ClockCard rests above the password card. While `moving` (idle) it
// drifts around like the old DVD-player screensaver: constant speed, bounces
// off the edges, new color on every wall hit. When `moving` turns false it
// glides back home.
import QtQuick

Item {
    id: root

    property bool moving: false
    // y of the clock's bottom edge when at rest
    property real homeBottom: 0
    readonly property real homeX: (width - card.width) / 2
    readonly property real homeY: homeBottom - card.height
    readonly property real speed: 200 // px/s along the direction of travel
    readonly property var palette: [Pywal.color1, Pywal.color2, Pywal.color3, Pywal.color4, Pywal.color5, Pywal.color6, Pywal.color9, Pywal.color10, Pywal.color11, Pywal.color12, Pywal.color13, Pywal.color14]
    readonly property int homeColorIndex: 5 // color6, ClockCard's usual color
    property real vx: 0
    property real vy: 0
    property int colorIndex: homeColorIndex

    function nextColor() {
        let i = Math.floor(Math.random() * (palette.length - 1));
        colorIndex = i >= colorIndex ? i + 1 : i;
    }

    function bindHome() {
        card.x = Qt.binding(() => {
            return root.homeX;
        });
        card.y = Qt.binding(() => {
            return root.homeY;
        });
    }

    function startMoving() {
        glide.stop();
        // 20°–70° off the x axis, random quadrant: never near-horizontal/vertical
        const angle = (20 + Math.random() * 50) * Math.PI / 180;
        vx = Math.cos(angle) * speed * (Math.random() < 0.5 ? -1 : 1);
        vy = Math.sin(angle) * speed * (Math.random() < 0.5 ? -1 : 1);
        // Plain assignments break the home bindings
        card.x = card.x;
        card.y = card.y;
        frames.start();
    }

    function goHome() {
        frames.stop();
        colorIndex = homeColorIndex;
        glide.restart();
    }

    onMovingChanged: moving ? startMoving() : goHome()
    Component.onCompleted: bindHome()

    ClockCard {
        id: card

        baseColor: root.palette[root.colorIndex]
    }

    ParallelAnimation {
        id: glide

        onFinished: root.bindHome()

        NumberAnimation {
            target: card
            property: "x"
            to: root.homeX
            duration: 400
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: card
            property: "y"
            to: root.homeY
            duration: 400
            easing.type: Easing.OutCubic
        }

    }

    FrameAnimation {
        id: frames

        onTriggered: {
            const maxX = Math.max(0, root.width - card.width);
            const maxY = Math.max(0, root.height - card.height);
            // Cap the step so a stalled frame doesn't teleport the card
            const dt = Math.min(frameTime, 0.1);
            let x = card.x + root.vx * dt;
            let y = card.y + root.vy * dt;
            let hit = false;
            if (x <= 0 || x >= maxX) {
                x = Math.min(Math.max(x, 0), maxX);
                root.vx = x <= 0 ? Math.abs(root.vx) : -Math.abs(root.vx);
                hit = true;
            }
            if (y <= 0 || y >= maxY) {
                y = Math.min(Math.max(y, 0), maxY);
                root.vy = y <= 0 ? Math.abs(root.vy) : -Math.abs(root.vy);
                hit = true;
            }
            card.x = x;
            card.y = y;
            if (hit)
                root.nextColor();

        }
    }

}
