#!/bin/bash

swaync_tag='string:x-canonical-private-synchronous:wl-clipboard-text-notifier'
dunst_tag='string:x-dunst-stack-tag:wl-clipboard-text-notifier'

send_text_notification() {
	content="$(wl-paste)"
	# Don't send text notification if a recording software like obs is running,
	# to protect sensitive data like copied password.
	if ! pgrep obs; then
		ACTION=$(notify-send \
			-a Clipboard \
			-h "$swaync_tag" \
			-h "$dunst_tag" \
			-i "accessories-clipboard" \
			--action="openGedit=Open editor" \
			"Clipboard" "Copied text to clipboard:\n$content")
		case "$ACTION" in
			"openGedit")
				wl-paste | gedit - &
				;;
			"2")
				;;
		esac
	fi
}

send_text_notification &
