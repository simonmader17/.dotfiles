#!/bin/bash

swaync_tag='string:x-canonical-private-synchronous:wallpaper-setter'
dunst_tag='string:x-dunst-stack-tag:wallpaper-setter'

notify-send -h "$swaync_tag" -h "$dunst_tag" -i ~/dotfiles/scripts/pywal/pywal-icon.png "Wallpaper Setter" "Setting \"$1\" as wallpaper..."
wal -i "$1" --backend colorz -o ~/dotfiles/scripts/pywal/post-pywal.sh |
while read -r line; do
	notify-send -h "$swaync_tag" -h "$dunst_tag" -i ~/dotfiles/scripts/pywal/pywal-icon.png "Wallpaper Setter" "${line##*: }"
done

# On wayland
# if type swww; then
# 	pgrep swww || swww init
# 	swww img "$1"
# fi

if [ "${PIPESTATUS[0]}" = 0 ]
then notify-send -h "$swaync_tag" -h "$dunst_tag" -i ~/dotfiles/scripts/pywal/pywal-icon.png "Wallpaper Setter" "Successfully set wallpaper."
else notify-send -h "$swaync_tag" -h "$dunst_tag" -i ~/dotfiles/scripts/pywal/pywal-icon.png -u critical "Wallpaper Setter" "Failed to set wallpaper."
fi
