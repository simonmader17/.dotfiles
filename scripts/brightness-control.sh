#!/usr/bin/env bash
# Usage: ./brightness-control.sh { up | down }

swaync_tag='string:x-canonical-private-synchronous:brightness-control'
dunst_tag='string:x-dunst-stack-tag:brightness-control'

icon_high="display-brightness-high-symbolic"
icon_medium="display-brightness-medium-symbolic"
icon_low="display-brightness-low-symbolic"

function get_brightness {
	echo $(($(brightnessctl g) * 100 / $(brightnessctl m)))
}

function send_notification {
	brightness=$(($(get_brightness)))
	if [ "$brightness" -ge 70 ]; then
		icon="$icon_high"
	elif [ "$brightness" -ge 30 ]; then
		icon="$icon_medium"
	else
		icon="$icon_low"
	fi
	notify-send -a Brightness -h "$swaync_tag" -h "$dunst_tag" -i "$icon" -u "low" "$brightness%" -h "int:value:$brightness"
}

case $1 in
	up)
		brightnessctl -q set +5%
		send_notification
		;;
	down)
		brightnessctl -q set 5%-
		send_notification
		;;
esac
