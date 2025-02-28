#!/usr/bin/env bash

send_text_notification() {
	# Don't send text notification if a recording software like obs is running,
	# to protect sensitive data like copied password.
	if ! pgrep obs; then
		ACTION=$(dunstify -h string:x-dunst-stack-tag:xclip-notifier -i "accessories-clipboard" -u low --action="default,openGedit" "Copied text to clipboard" "$content")
		case "$ACTION" in
			"default")
				xclip -selection clipboard -o | gedit - &
				;;
			"2")
				;;
		esac
	fi
}

send_image_notification() {
	tmpfile=$(mktemp)
	xclip -selection clipboard -t image/png -o > $tmpfile
	ACTION=$(dunstify -h string:x-dunst-stack-tag:xclip-notifier -i $tmpfile -u low --action="default,openGimp" "Copied image to clipboard")
	case "$ACTION" in
		"default")
			gimp $tmpfile &
			;;
		"2")
			;;
	esac
}

if xclip -selection clipboard -t image/png -o >/dev/null; then
	prev_content=$(xclip -selection clipboard -t image/png -o)
elif xclip -selection clipboard -o >/dev/null; then
	prev_content=$(xclip -selection clipboard -o)
fi

while clipnotify; do
	if xclip -selection clipboard -t image/png -o >/dev/null; then
		content=$(xclip -selection clipboard -t image/png -o)
		if [ "$content" != "$prev_content" ]; then
			send_image_notification &
		fi
	elif xclip -selection clipboard -o >/dev/null; then
		content=$(xclip -selection clipboard -o)
		if [ "$content" != "$prev_content" ]; then
			send_text_notification &
		fi
	fi
	prev_content="$content"
done
