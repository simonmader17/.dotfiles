local default_gaps_in = hl.get_config("general.gaps_in").top
local default_gaps_out = hl.get_config("general.gaps_out").top
local default_rounding = hl.get_config("decoration.rounding")

hl.bind("SUPER + SHIFT + MINUS", function ()
	local new_gaps_in = math.max(hl.get_config("general.gaps_in").top - 5, 0)
	local new_gaps_out = math.max(hl.get_config("general.gaps_out").top - 5, 0)
	hl.config({
		general = {
			gaps_in = new_gaps_in,
			gaps_out = new_gaps_out,
		},
	})
	if new_gaps_in == 0 and new_gaps_out == 0 then
		hl.config({ decoration = { rounding = 0 } })
	end
end, { repeating = true })
hl.bind("SUPER + SHIFT + PLUS", function ()
	local current_gaps_in = hl.get_config("general.gaps_in").top
	local current_gaps_out = hl.get_config("general.gaps_out").top
	if current_gaps_in == 0 and current_gaps_out == 0 then
		hl.config({ decoration = { rounding = default_rounding } })
	end
	local new_gaps_in = current_gaps_in + 5
	local new_gaps_out = current_gaps_out + 5
	hl.config({
		general = {
			gaps_in = new_gaps_in,
			gaps_out = new_gaps_out,
		},
	})
end, { repeating = true })
hl.bind("SUPER + SHIFT + BACKSPACE", function ()
	hl.config({
		general = { gaps_in = default_gaps_in, gaps_out = default_gaps_out },
		decoration = { rounding = default_rounding },
	})
end)
