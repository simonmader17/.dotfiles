// Globals.qml
pragma Singleton

import QtQuick
import Quickshell

Singleton {
	readonly property font myFont: ({
		family: "CaskaydiaCove Nerd Font",
		pixelSize: 14,
		bold: true
	})

	readonly property font myIconFont: ({
		family: "Material Symbols Outlined",
		pixelSize: 20,
		variableAxes: {
			"FILL": 1,
			"GRAD": 0,
			"opsz": 20,
			"wght": 700
		}
	})

	readonly property font myIconFontOutlined: ({
		family: "Material Symbols Outlined",
		pixelSize: 24,
		variableAxes: {
			"FILL": 0,
			"GRAD": 0,
			"opsz": 20,
			"wght": 700
		}
	})

	readonly property var myIconFontRenderType: Text.CurveRendering

	function guessIcon(id) {
		switch (id) {
			// custom icon mappings
			case "terminal-floating": return "kitty";
		}
		const byId = DesktopEntries.byId(id);
		if (byId) return byId.icon;
		const heuristicLookup = DesktopEntries.heuristicLookup(id);
		if (heuristicLookup) return heuristicLookup.icon;
		return "application-x-executable";
	}
}
