#!/bin/bash
if type Hyprland; then
	xcolors=$(cat ~/.cache/wal/colors.json)
	sss \
		--notify \
		--screen-id DP-2 \
		--background "$(echo "$xcolors" | jq -r '.special.background')" \
		--author-color "$(echo "$xcolors" | jq -r '.colors.color7')" \
		--fonts "CaskaydiaCove Nerd Font=18.0;" \
		--author-font "CaskaydiaCove Nerd Font" \
		--author "simonmader17" \
		--shadow --shadow-image \
		-o "/mnt/d/Fotos/sss/$(date "+%Y-%m-%d_%H-%M-%S").png" && nautilus /mnt/d/Fotos/sss/
else
	sss \
		--notify \
		--area "0,0 1920x1080" \
		--background "$(xrdb -get background)" \
		--author-color "$(xrdb -get color7)" \
		--fonts "CaskaydiaCove Nerd Font=18.0;" \
		--author-font "CaskaydiaCove Nerd Font" \
		--shadow --shadow-image \
		-o "/mnt/d/Fotos/sss/$(date "+%Y-%m-%d_%H-%M-%S").png" && nautilus /mnt/d/Fotos/sss/
fi
