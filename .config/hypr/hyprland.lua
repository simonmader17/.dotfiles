-- ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗
-- ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
-- ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
-- ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
-- ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
-- ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝
-- https://wiki.hypr.land/Configuring/Start/

local HOME = os.getenv("HOME")
local colors = require("colors")

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
-- configure monitors in hyprland-overrides.lua per device

---------------------
---- MY PROGRAMS ----
---------------------

local browser = "brave-origin-nightly"
local browser_incognito_flag = "--incognito"
local file_manager = "nemo"
local menu = HOME .. "/.config/rofi/launch.sh"
local menu_dmenu = HOME .. "/.config/rofi/launch-dmenu.sh"
local menu_emoji = HOME .. "/.config/rofi/launch-emoji.sh"
local menu_run = HOME .. "/.config/rofi/launch-run.sh"
local terminal = "kitty"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("gammastep -l 48.1:16.2 -t 6500:4000")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("sleep 1; nextcloud")
	hl.exec_cmd("sleep 1; nm-applet")
	hl.exec_cmd("sleep 1; uwsm app -- awww-daemon")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("systemctl --user start wl-clipboard-notifier.service")
	hl.exec_cmd("uwsm app -- hypridle")
	hl.exec_cmd("uwsm app -- swaync")
	hl.exec_cmd("wal -R")
	hl.exec_cmd(HOME .. "/.config/quickshell/toggle.sh")

	-- Autostart apps on "✉️" named workspace, as autostarting apps on special
	-- workspace is not working
	hl.exec_cmd("signal-desktop", { workspace = "name:✉️ silent" })
	hl.exec_cmd("thunderbird", { workspace = "name:✉️ silent" })
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Toolkit env variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt variables
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- hl.env("QT_STYLE_OVERRIDE", "kvantum")

-------------------------
---- CURSOR SETTINGS ----
-------------------------

hl.exec_cmd(
	"gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic"
)
hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "bibata-cursor-git")
hl.env("HYPRCURSOR_SIZE", "24")
hl.config({
	cursor = {
		no_hardware_cursors = 1,
		inactive_timeout = 5,
	},
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 5,

		col = {
			active_border = {
				colors = { colors.color1, colors.color4 },
				angle = 45,
			},
			inactive_border = colors.color0,
		},

		layout = "dwindle",
		allow_tearing = false,
	},

	dwindle = {
		force_split = 2,
		precise_mouse_move = true,
	},

	decoration = {
		rounding = 14,

		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			xray = true,
			popups = true,
		},

		shadow = {
			enabled = true,
			range = 300,
			offset = { 0, 40 },
			scale = 0.9,
			render_power = 4,
			color = "#00000066",
		},
	},

	animations = {
		enabled = true,
	},

	binds = {
		movefocus_cycles_fullscreen = false,
	},

	gestures = {
		workspace_swipe_touch = true,
	},

	misc = {
		disable_hyprland_logo = true,
		background_color = colors.background,
		animate_manual_resizes = true,
		middle_click_paste = false,
		enable_anr_dialog = false,
	},
})

-- stylua: ignore start
-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
-- stylua: ignore end

-----------------
---- PLUGINS ----
-----------------

if hl.plugin.hyprexpo ~= nil then
	hl.config({
		plugin = {
			hyprexpo = {
				columns = 2,
				gap_size = 5,
				bg_col = colors.background,
				skip_empty = true,
			},
		},
	})
end
if hl.plugin.hyprgrass ~= nil then
	hl.config({
		plugin = {
			touch_gestures = {
				sensitivity = 4.0,
				workspace_swipe_fingers = 3,
				workspace_swipe_edge = "d",
				-- ["hyprgrass-bindm"] = ", longpress:2, movewindow",
				-- ["hyprgrass-bindm"] = ", longpress:3, resizewindow",
			},
		},
	})
end
if hl.plugin.hyprtrails ~= nil then
	hl.config({
		plugin = {
			hyprtrails = {
				color = colors.color2 .. "aa",
			},
		},
	})
end

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "de",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_rate = 40,
		repeat_delay = 200,

		follow_mouse = 2,
		float_switch_override_focus = 0,

		sensitivity = 0,
		accel_profile = "flat",

		touchpad = {
			natural_scroll = true,
		},

		tablet = {
			output = "current",
		},
	},
})

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.window.center())

-- Programs
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(
	"SUPER + SHIFT + RETURN",
	hl.dsp.exec_cmd(terminal .. ' --class="terminal-floating"')
)
hl.bind("CONTROL + SHIFT + ESCAPE", hl.dsp.exec_cmd("missioncenter"))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + COMMA", hl.dsp.exec_cmd(menu_emoji))
hl.bind("SUPER + CONTROL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + CONTROL + S", hl.dsp.exec_cmd("shazam-notif"))
hl.bind("SUPER + E", hl.dsp.exec_cmd(file_manager))
hl.bind("SUPER + INSERT", hl.dsp.exec_cmd(HOME .. "/scripts/my-rofi-rbw.sh"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + S", hl.dsp.exec_cmd("spotify-launcher"))
hl.bind(
	"SUPER + SHIFT + B",
	hl.dsp.exec_cmd(browser .. " " .. browser_incognito_flag)
)
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(HOME .. "/scripts/dictionary.sh"))
hl.bind("SUPER + SHIFT + PERIOD", hl.dsp.exec_cmd(menu_run))
hl.bind(
	"SUPER + SHIFT + R",
	hl.dsp.exec_cmd(HOME .. "/.config/quickshell/toggle.sh")
)
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("chatterino"))
hl.bind(
	"SUPER + SHIFT + W",
	hl.dsp.exec_cmd(HOME .. "/scripts/pywal/random-wallpaper.sh")
)
hl.bind("SUPER + T", hl.dsp.exec_cmd("teamspeak3"))
hl.bind("SUPER + W", hl.dsp.exec_cmd(HOME .. "/scripts/wallpapers.sh"))

-- Clipboard
hl.on("hyprland.start", function ()
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
hl.bind(
	"SUPER + V",
	hl.dsp.exec_cmd(
		"cliphist list | " .. menu_dmenu .. " | cliphist decode | wl-copy"
	)
)

-- Screenshots
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.exec_cmd(
		"wayfreeze --after-freeze-cmd 'slurp | grim -g - - | { swappy -f - & }; killall wayfreeze'"
	)
)

-- Audio controls
local l = { locked = true }
local r = { repeating = true }
local lr = { locked = true, repeating = true }
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+"),
	lr
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%-"),
	lr
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ togglr"),
	lr
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ togglr"),
	lr
)

-- Spotify controls
local sptfy = "playerctl --player spotify"
for _, keys in ipairs({
	"XF86AudioPrev",
	"XF86Launch5",
	"SUPER + CONTROL + LEFT",
}) do
	hl.bind(keys, hl.dsp.exec_cmd(sptfy .. " previous"), l)
end
for _, keys in ipairs({
	"XF86AudioPlay",
	"XF86Launch6",
	"SUPER + CONTROL + DOWN",
}) do
	hl.bind(keys, hl.dsp.exec_cmd(sptfy .. " play-pause"), l)
end
for _, keys in ipairs({
	"XF86AudioNext",
	"XF86Launch7",
	"SUPER + CONTROL + RIGHT",
}) do
	hl.bind(keys, hl.dsp.exec_cmd(sptfy .. " next"), l)
end
hl.bind("SUPER + MINUS", hl.dsp.exec_cmd(sptfy .. " volume 0.1-"), lr)
hl.bind("SUPER + PLUS", hl.dsp.exec_cmd(sptfy .. " volume 0.1+"), lr)

-- Brightness controls
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(HOME .. "/scripts/brightness-control.sh down"),
	lr
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(HOME .. "/scripts/brightness-control.sh up"),
	lr
)

-- Move focus/window
local vim_keys = { "H", "J", "K", "L" }
local dirs = { "left", "down", "up", "right" }
for i = 1, 4 do
	local dir = { direction = dirs[i] }
	hl.bind("SUPER + " .. vim_keys[i], hl.dsp.focus(dir))
	hl.bind("SUPER + " .. dirs[i], hl.dsp.focus(dir))
	hl.bind("SUPER + SHIFT + " .. vim_keys[i], hl.dsp.window.move(dir))
	hl.bind("SUPER + SHIFT + " .. dirs[i], hl.dsp.window.move(dir))
end

-- Resize window
hl.bind("SUPER + SHIFT + Z", hl.dsp.window.resize({ x = -20, y = 0 }), r)
hl.bind("SUPER + SHIFT + U", hl.dsp.window.resize({ x = 0, y = -20 }), r)
hl.bind("SUPER + SHIFT + I", hl.dsp.window.resize({ x = 0, y = 20 }), r)
hl.bind("SUPER + SHIFT + O", hl.dsp.window.resize({ x = 20, y = 0 }), r)

-- Resize gaps
require("gaps")

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Toggle fullscreen
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Switch workspace with SUPER + [0-9]
-- Move active window to a workspace with SUPER + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

local function toggle_workspace (target_ws_selector)
	local target_ws = hl.get_workspace(target_ws_selector)
	if target_ws == nil then
		return
	end
	local active_ws = hl.get_active_workspace()
	if target_ws == active_ws then
		hl.dispatch(hl.dsp.focus({ workspace = "previous_per_monitor" }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. target_ws.name }))
	end
end
hl.bind("SUPER + PAGE_DOWN", function ()
	toggle_workspace("name:✉️")
end)
hl.bind("SUPER + PAGE_UP", function ()
	toggle_workspace("name:✉️")
end)
hl.bind(
	"SUPER + SHIFT + PAGE_DOWN",
	hl.dsp.window.move({ workspace = "name:✉️" })
)
hl.bind(
	"SUPER + SHIFT + PAGE_UP",
	hl.dsp.window.move({ workspace = "name:✉️" })
)

-- Gamemode / Battery saver mode
require("gamemode")

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- hl.gesture({ fingers = 3, direction = "down", action = "hyprexpo:expo on" })
-- hl.gesture({ fingers = 3, direction = "up", action = "hyprexpo:expo off" })

--------------------------------
---- WINDOW AND LAYER RULES ----
--------------------------------

-- Layer rules
hl.layer_rule({
	match = { namespace = "^(quickshell|rofi|swaync-control-center|waybar)$" },
	blur = true,
	ignore_alpha = 0.5,
})

-- General window rules
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { float = "false" }, no_shadow = true })

-- Program specific window rules
hl.window_rule({
	match = { class = "com.libretro.RetroArch" },
	fullscreen = true,
})
hl.window_rule({
	match = { class = "com.nextcloud.desktopclient.nextcloud" },
	float = true,
})
hl.window_rule({
	match = {
		class = "com.nextcloud.desktopclient.nextcloud",
		title = "Nextcloud",
	},
	move = { "cursor_x", 44 },
	size = { 400, 500 },
})
hl.window_rule({ match = { class = "gamescope" }, immediate = true })
hl.window_rule({ match = { class = "jetbrains-idea" }, opacity = 0.9 })
hl.window_rule({
	match = { class = "jetbrains-idea-ce", title = "^win(.*)" },
	no_initial_focus = true,
})
hl.window_rule({
	match = { class = "mpv" },
	center = true,
	float = true,
	max_size = { "0.8 * monitor_w", "0.8 * monitor_h" },
})
hl.window_rule({
	match = { class = "nemo" },
	center = true,
	float = true,
	opacity = 0.9,
})
hl.window_rule({
	match = { class = "Nsxiv" },
	center = true,
	float = true,
	size = { "0.6 * monitor_w", "0.8 * monitor_h" },
})
hl.window_rule({ match = { class = "Peek" }, no_blur = true })
hl.window_rule({ match = { class = "spotify" }, opacity = 0.9 })
hl.window_rule({
	match = { class = "terminal-floating" },
	center = true,
	float = true,
	max_size = { "0.6 * monitor_w", "0.8 * monitor_h" },
})

------------------------------
---- PER DEVICE OVERRIDES ----
------------------------------
require("hyprland-overrides")
