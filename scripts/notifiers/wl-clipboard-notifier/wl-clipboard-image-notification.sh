#!/bin/bash

swaync_tag='string:x-canonical-private-synchronous:wl-clipboard-image-notifier'
dunst_tag='string:x-dunst-stack-tag:wl-clipboard-image-notifier'

send_image_notification() {
	tmpfile=$(mktemp)
	wl-paste --type image/png > "$tmpfile"
	[ ! -s "$tmpfile" ] && exit 0
	ACTION=$(notify-send \
		-a Clipboard \
		-h "$swaync_tag" \
		-h "$dunst_tag" \
		-i "$tmpfile" \
		--action="imgur=Upload image to imgur" \
		--action="gimp=Open image in gimp" \
		"Clipboard" "Saved image to clipboard")
	case "$ACTION" in
		"imgur")
			notify-send \
				-a Clipboard \
				-h "$swaync_tag" \
				-h "$dunst_tag" \
				-i "$tmpfile" \
				"Imgur" "Uploading image to <i>imgur</i>..."
			IMGUR_TEXT=$(~/scripts/grimshot/imgur.sh/imgur.sh "$tmpfile" 2>&1)
			IMGUR_LINK=$(echo "$IMGUR_TEXT" | grep -o 'https://i.imgur.com/.*')
			wl-copy "$IMGUR_LINK"
			IMGUR_DELETE_LINK=$(echo "$IMGUR_TEXT" | grep -o 'https://imgur.com/delete/.*')
			ACTION_IMGUR=$(notify-send \
				-a Clipboard \
				-h "$swaync_tag" \
				-h "$dunst_tag" \
				-i "$tmpfile" \
				--action="openImgur=Open imgur link" \
				--action="deleteImgur=Delete imgur link" \
				"Imgur" "Uploaded image to <i>imgur</i>.\nCopied link to clipboard.")
			case "$ACTION_IMGUR" in
				"openImgur")
					xdg-open "$IMGUR_LINK"
					;;
				"deleteImgur")
					xdg-open "$IMGUR_DELETE_LINK"
					;;
				"2")
					;;
			esac
			;;
		"gimp")
			gimp $tmpfile &
			;;
		"2")
			;;
	esac
}

send_image_notification &
