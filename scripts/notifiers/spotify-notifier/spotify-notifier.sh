#!/usr/bin/env bash

swaync_tag='string:x-canonical-private-synchronous:spotify-notifier'
dunst_tag='string:x-dunst-stack-tag:spotify-notifier'

# The cover art images will be saved in /tmp/spotify-notifier/<hash of cover art
# URL>.
# If a file for a URL already exists, it will not be fetched again.
cache_dir="/tmp/spotify-notifier"
mkdir "$cache_dir"

rm_cached_files() {
	echo "Removing cached files"
	rm -rf "$cache_dir"
}
trap rm_cached_files SIGINT SIGTERM

# Hash function
hash() {
	md5sum | cut -d" " -f1
}

# send_notification()
#
# $1 ... pause/resume icon
# $2 ... true if volume bar should be shown
send_notification() {
	if playerctl --player=spotify status; then
		title=$(playerctl --player=spotify metadata title)
		artist=$(playerctl --player=spotify metadata artist)
		album=$(playerctl --player=spotify metadata album)
		let volume=$(echo "$(playerctl --player=spotify volume) * 100 / 1" | bc)

		iconurl=$(playerctl --player=spotify metadata mpris:artUrl)
		if [ -z "$iconurl" ]; then
			icon=""
		else
			iconfile="$(echo "$iconurl" | hash)"
			icon="$cache_dir/$iconfile"
			if [ -s "$icon" ]; then
				echo "Icon has already been fetched: $icon"
			else
				echo "Fetching icon and saving to $icon"
				curl "$iconurl" > "$icon" || icon=""
			fi
		fi

		if [ "$2" = "true" ]; then
			notify-send \
				-a spotify-launcher \
				-h "$swaync_tag" \
				-h "$dunst_tag" \
				-h "int:value:$volume" \
				-i "$icon" \
				"$1$title" \
				"$artist\nAlbum: <i>$album</i>" 
		else
			notify-send \
				-a spotify-launcher \
				-h "$swaync_tag" \
				-h "$dunst_tag" \
				-i "$icon" \
				"$1$title" \
				"$artist\nAlbum: <i>$album</i>"
		fi
	fi
}

follow_status() {
	playerctl --player=spotify --follow status |
	while read line; do
		if [ "$line" = "Playing" ]; then
			send_notification " "
		else
			send_notification " "
		fi
	done
}

follow_title() {
	playerctl --player=spotify --follow metadata title |
	while read line; do
		send_notification
	done
}

follow_volume() {
	playerctl --player=spotify --follow volume |
	while read line; do
		send_notification "" true
	done
}

follow_status &
follow_title &
follow_volume
