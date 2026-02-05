// Colors.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property string background
	property string foreground
	property string color0
	property string color1
	property string color2
	property string color3
	property string color4
	property string color5
	property string color6
	property string color7
	property string color8
	property string color9
	property string color10
	property string color11
	property string color12
	property string color13
	property string color14
	property string color15

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
