#!/usr/bin/env bash
if grimshot copy area; then
	tmpfile=$(mktemp)
	wl-paste > "$tmpfile"
	action=$(dunstify \
		-h string:x-dunst-stack-tag:grimshot-area-imgur \
		-i "$tmpfile" \
		--action="imgur,Upload image to imgur" \
		--action="gimp,Open image in gimp" \
		"Grimshot" "Saved image to clipboard.")
	case "$action" in
		"imgur")
			dunstify \
				-h string:x-dunst-stack-tag:grimshot-area-imgur \
				-i "$tmpfile" \
				"Grimshot" "Uploading image to <i>imgur</i>..."
			~/scripts/grimshot/imgur.sh/imgur.sh "$tmpfile" | awk '{print $1}' | wl-copy -n
			action2=$(dunstify \
				-h string:x-dunst-stack-tag:grimshot-area-imgur \
				-i "$tmpfile" \
				--action="default,Open imgur link in browser" \
				"Grimshot" "Uploaded image to <i>imgur</i>.\nCopied link to clipboard.")
			case "$action2" in
				"default")
					xdg-open "$(wl-paste)"
					;;
				"2")
					;;
			esac
			;;
		"gimp")
			gimp "$tmpfile" &
			;;
		"2")
			;;
	esac
fi
