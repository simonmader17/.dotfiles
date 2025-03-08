#!/usr/bin/env bash

swaync_tag='string:x-canonical-private-synchronous:wl-clipboard-text-notifier'
dunst_tag='string:x-dunst-stack-tag:wl-clipboard-text-notifier'

send_text_notification() {
	# Don't send text notification if a recording software like obs is running,
	# to protect sensitive data like copied password.
	pgrep obs && exit 0

	content="$(wl-paste)"
	[ -z "$content" ] && exit 0
	actions=(--action="openGedit=Open editor")
	if [[ "$content" =~ ^https://artvee.com/dl/.* ]]; then
		actions+=(--action="avdl=Download artwork")
	fi
	ACTION=$(notify-send \
		-a Clipboard \
		-h "$swaync_tag" \
		-h "$dunst_tag" \
		-i "accessories-clipboard" \
		"${actions[@]}" \
		"Clipboard" "Copied text to clipboard:\n$content")
	case "$ACTION" in
		"openGedit")
			wl-paste | gedit - &
			;;
		"avdl")
			notify-send \
				-a Clipboard \
				-h "$swaync_tag" \
				-h "$dunst_tag" \
				-i "accessories-clipboard" \
				"Clipboard - Artvee" "Downloading artwork..."
			cd "$WALLS/artvee/"
			artwork="$(~/scripts/avdl.sh "$content" | tail -n1)"
			ACTION=$(notify-send \
				-a Clipboard \
				-h "$swaync_tag" \
				-h "$dunst_tag" \
				-i "$WALLS/artvee/$artwork" \
				--action="openArtwork=Open artwork" \
				"Clipboard - Artvee" "Downloaded artwork: $artwork")
			case "$ACTION" in
				"openArtwork")
					nsxiv "$WALLS/artvee/$artwork" &
					;;
				"2")
					;;
			esac
			;;
		"2")
			;;
	esac
}

send_text_notification &
