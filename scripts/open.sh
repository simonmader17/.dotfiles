#!/usr/bin/env bash

# This script opens the file that has been produced by the `compile.sh` script.
# I bind this to <leader>o in vim.

[[ -f "$1" ]] || exit 1
file="$(realpath -- "$1")"
ext="${file##*.}"
ext="${ext,,}"
dir=${file%/*}
base="${file%.*}"

NID="$(notify-send -a nvim -p "open.sh" "Opening matching file for $file...")"

cd "$dir" || exit 1

case "$ext" in
	dot)
		if [[ -f "$base.svg" ]]; then
			nsxiv "$base.svg" &
		else
			notify-send -a nvim -r "$NID" "open.sh" "No matching .svg file found."
			exit 1
		fi
		;;
	mom|ms) ;&
	tex) ;&
	typ)
		if [[ -f "$base.pdf" ]]; then
			zathura "$base.pdf" &
		else
			notify-send -a nvim -r "$NID" "open.sh" "No matching .pdf file found."
			exit 1
		fi
		;;
	md)
		if sed -n '/^---$/,/^---$/p' "$file" | grep -qi "html: true"; then
			if [[ -f "$base.html" ]]; then
				kitty \
					--working-directory "$dir" \
					-- live-server "$dir" --open="${base##*/}.html" &
			else
				notify-send -a nvim -r "$NID" "open.sh" "No matching .html file found."
				exit 1
			fi
		else
			if [[ -f "$base.pdf" ]]; then
				zathura "$base.pdf" &
			else
				notify-send -a nvim -r "$NID" "open.sh" "No matching .pdf file found."
				exit 1
			fi
		fi
		;;
	puml)
		if [[ -f "$base.png" ]]; then
			nsxiv "$base.png" &
		else
			notify-send -a nvim -r "$NID" "open.sh" "No matching .png file found."
			exit 1
		fi
		;;
	*)
		notify-send -a nvim -r "$NID" "open.sh" "Can't find file to open."
		exit 1
		;;
esac

notify-send -a nvim -r "$NID" -t 2000 "open.sh" "Opened matching file for $file."
