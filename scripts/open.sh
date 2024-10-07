#!/bin/bash

# This script opens the file that has been produced by the `compile.sh` script.
# I bind this to <leader>o in vim.

file="${1}"
ext="${file##*.}"
dir=${file%/*}
base="${file%.*}"

cd "$dir" || exit 1

case "$ext" in
	mom|ms) ;&
	tex)
		[ -f "$base.pdf" ] &&
			{ zathura "$base.pdf" & } ||
			notify-send -a nvim "open.sh" "No matching .pdf file found."
		;;
	md)
		sed -n '/^---$/,/^---$/p' "$file" | grep -qi "html: true" &&
			{
				[ -f "$base.html" ] &&
					{ kitty \
						--working-directory "$dir" \
						-- live-server "$dir" --open="${base##*/}.html" & } ||
					notify-send -a nvim "open.sh" "No matching .html file found."
			} ||
			{
				[ -f "$base.pdf" ] &&
					{ zathura "$base.pdf" & } ||
					notify-send -a nvim "open.sh" "No matching .pdf file found."
			}
		;;
	*) notify-send -a nvim "open.sh" "Can't find file to open." ;;
esac
