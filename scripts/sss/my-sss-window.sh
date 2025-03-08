#!/bin/bash

if type Hyprland; then
	xcolors=$(cat ~/.cache/wal/colors.json)
	sss \
		--notify \
		--area "$(slurp)" \
		--background "$(echo "$xcolors" | jq -r '.special.background')" \
		--author-color "$(echo "$xcolors" | jq -r '.colors.color7')" \
		--fonts "CaskaydiaCove Nerd Font=18.0;" \
		--author-font "CaskaydiaCove Nerd Font" \
		--author "simonmader17" \
		--shadow --shadow-image \
		--window-title "$1" \
		--window-controls \
		--window-background "#313131" \
		--window-title-color "$(echo "$xcolors" | jq -r '.colors.color7')" \
		-o "$PIX/sss/$(date "+%Y-%m-%d_%H-%M-%S").png" && nautilus "$PIX/sss/"
else
	sss \
		--notify \
		--area "$(my-slop)" \
		--background "$(xrdb -get background)" \
		--author-color "$(xrdb -get color7)" \
		--fonts "CaskaydiaCove Nerd Font=18.0;" \
		--author-font "CaskaydiaCove Nerd Font" \
		--shadow --shadow-image \
		--window-title "$1" \
		--window-controls \
		--window-background "#313131" \
		--window-title-color "$(xrdb -get color7)" \
		-o "$PIX/sss/$(date "+%Y-%m-%d_%H-%M-%S").png" && nautilus "$PIX/sss/"
fi
