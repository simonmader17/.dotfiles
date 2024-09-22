#!/bin/bash

# Add transparency to background and color6
# dunstify -h string:x-dunst-stack-tag:wallpaper-setter -i ~/dotfiles/scripts/pywal/pywal-icon.png "Wallpaper Setter" "Adding transparency to background for Polybar."
background="$(xrdb -get background)"
echo "*background-transparent: ${background:0:1}AA${background:1}" >> ~/.cache/wal/colors.Xresources
color6="$(xrdb -get color6)"
echo "*color6-transparent: ${color6:0:1}CC${color6:1}" >> ~/.cache/wal/colors.Xresources
xrdb -merge ~/.cache/wal/colors.Xresources

WALLPAPER="$(cat ~/.cache/wal/colors.json | jq ".wallpaper" -r)"

# On wayland
if type swww; then
	pgrep swww || swww init
    swww img --transition-type outer --transition-pos 0.97,0.99 --transition-step 90 "$WALLPAPER"
fi
type waybar && ~/dotfiles/waybar/launch.sh && ~/dotfiles/waybar/launch.sh &

# Update betterlockscreen background
# dunstify -h string:x-dunst-stack-tag:wallpaper-setter -i ~/dotfiles/scripts/pywal/pywal-icon.png "Wallpaper Setter" "Updating betterlockscreen background."
type betterlockscreen && betterlockscreen -u "$WALLPAPER" --fx

# Link /usr/share/Pictures/lockscreen to wallpaper
# dunstify -h string:x-dunst-stack-tag:wallpaper-setter -i ~/dotfiles/scripts/pywal/pywal-icon.png "Wallpaper Setter" "Linking lockscreen image to wallpaper."
ln -sf "$WALLPAPER" /mnt/d/Wallpaper/lockscreen

# Generate chromium theme
# dunstify -h string:x-dunst-stack-tag:wallpaper-setter -i ~/dotfiles/scripts/pywal/pywal-icon.png "Wallpaper Setter" "Generating chromium theme."
~/sources/ChromiumPywal/generate-theme.sh
~/dotfiles/scripts/pywalium/generate.sh
ln -sf ~/sources/ChromiumPywal/Pywal ~/00-CHROMIUM-PYWAL-QUICK-ACCESS

# apply spicetify and restart notification service
type spicetify && (spicetify apply || spicetify restore backup apply)
systemctl --user restart spotify-notifier.service

# update pywalfox colors
~/.mozilla/firefox/simon-arkenfox/update-pywalfox.sh

# reload swaync
swaync-client --reload-css
