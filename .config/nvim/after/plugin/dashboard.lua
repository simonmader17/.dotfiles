local alpha = require("alpha")
local theme = require("alpha.themes.theta")

local my_art = {
	ansi_shadow = {
		"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
		"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
		"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
		"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
		"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
		"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
	},
	pikachu = {
		"",
		"          ▀████▀▄▄              ▄█ ",
		"            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
		"    ▄        █          ▀▀▀▀▄  ▄▀  ",
		"   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
		"  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
		"  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
		"   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
		"    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
		"   █   █  █      ▄▄           ▄▀   ",
	},
}

theme.header.val = my_art.pikachu

-- lolcat header:
--[[ require("alpha.term")
local my_header = {
	type = "terminal",
	command = '/usr/bin/figlet -f "ANSI Shadow" "Neovim" | lolcat',
	width = 50,
	height = 7,
	opts = {
		redraw = true,
		window_config = {}
	}
}
theme.header = my_header
theme.config.layout[2] = my_header ]]

alpha.setup(theme.config)
