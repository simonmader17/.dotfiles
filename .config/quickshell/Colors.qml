// Colors.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property color background
	property color foreground
	property color color0
	property color color1
	property color color2
	property color color3
	property color color4
	property color color5
	property color color6
	property color color7
	property color color8
	property color color9
	property color color10
	property color color11
	property color color12
	property color color13
	property color color14
	property color color15

	function loadPywalColors(data: string): void {
		const wal = JSON.parse(data);
		root.background = wal.special.background;
		root.foreground = wal.special.foreground;
		root.color0 = wal.colors.color0;
		root.color1 = wal.colors.color1;
		root.color2 = wal.colors.color2;
		root.color3 = wal.colors.color3;
		root.color4 = wal.colors.color4;
		root.color5 = wal.colors.color5;
		root.color6 = wal.colors.color6;
		root.color7 = wal.colors.color7;
		root.color8 = wal.colors.color8;
		root.color9 = wal.colors.color9;
		root.color10 = wal.colors.color10;
		root.color11 = wal.colors.color11;
		root.color12 = wal.colors.color12;
		root.color13 = wal.colors.color13;
		root.color14 = wal.colors.color14;
		root.color15 = wal.colors.color15;
	}

	FileView {
		path: Quickshell.env("HOME") + "/.cache/wal/colors.json"
		watchChanges: true
		onFileChanged: reload()
		onLoaded: root.loadPywalColors(text())
	}
}
