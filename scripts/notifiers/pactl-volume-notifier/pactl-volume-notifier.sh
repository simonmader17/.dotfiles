#!/usr/bin/env bash

swaync_tag='string:x-canonical-private-synchronous:xclip-notifier'
dunst_tag='string:x-dunst-stack-tag:xclip-notifier'

icon_overamplified="audio-volume-overamplified-symbolic"
icon_high="audio-volume-high-symbolic"
icon_medium="audio-volume-medium-symbolic"
icon_low="audio-volume-low-symbolic"
icon_muted="audio-volume-muted-symbolic"

prev_volume=""

pactl subscribe |
grep --line-buffered " sink " |
stdbuf -o0 cut -d# -f2 | # -o0 ... unbuffered; stdbuf runs the cut command unbuffered
while read index; do
	device=$(pactl list sinks | grep "Sink #$index" -A10 | grep "Description" | cut -d " " -f 2- | sed "s/\(.\{21\}\).*/\1.../")
	volumes=$(pactl get-sink-volume "$index" | grep -Po '\d+(?=%)')
	volume=$(echo "$volumes" | head -n 1) # assuming left and right volumes are equal
	if pactl get-sink-mute "$index" | grep "yes"; then
		muted=true
	else
		muted=false
	fi

	urg="low"
	if [ "$volume" -gt 100 ]; then
		icon="$icon_overamplified"
		urg="critical"
	elif [ "$volume" -ge 70 ]; then
		icon="$icon_high"
	elif [ "$volume" -ge 30 ]; then
		icon="$icon_medium"
	elif [ "$volume" -gt 0 ]; then
		icon="$icon_low"
	else
		icon="$icon_muted"
	fi

	if [[ "$muted" == true || "$volume" == 0 ]]; then
		summary="Muted [$device]"
		icon="$icon_muted"
	elif [ "$volume" -lt 100 ]; then
		summary=" $volume% [$device]"
	else
		summary="$volume% [$device]"
	fi
	if [ "$volume$muted" != "$prev_volume" ]; then
		notify-send -a Volume -h "$swaync_tag" -h "$dunst_tag" -u "$urg" -i "$icon" "$summary" -h "int:value:$volume"
		prev_volume="$volume$muted"
	fi
done
