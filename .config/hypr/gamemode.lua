local default_gaps_in = hl.get_config("general.gaps_in").top
local default_gaps_out = hl.get_config("general.gaps_out").top
local default_rounding = hl.get_config("decoration.rounding")
local default_blur_enabled = hl.get_config("decoration.blur.enabled")
local default_shadow_enabled = hl.get_config("decoration.shadow.enabled")
local default_animations_enabled = hl.get_config("animations.enabled")

local gamemode = false

hl.bind("SUPER + F1", function ()
	gamemode = not gamemode
	if gamemode then
		hl.config({
			general = {
				gaps_in = 0,
				gaps_out = 0,
			},
			decoration = {
				rounding = 0,
				blur = { enabled = false },
				shadow = { enabled = false },
			},
			animations = { enabled = false },
		})
	else
		hl.config({
			general = {
				gaps_in = default_gaps_in,
				gaps_out = default_gaps_out,
			},
			decoration = {
				rounding = default_rounding,
				blur = { enabled = default_blur_enabled },
				shadow = { enabled = default_shadow_enabled },
			},
			animations = { enabled = default_animations_enabled },
		})
	end
end)
