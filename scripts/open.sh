#!/bin/bash

# This script opens the file that has been produced by the `compile.sh` script.
# I bind this to <leader>o in vim.

file="${1}"
ext="${file##*.}"
dir=${file%/*}
base="${file%.*}"

cd "$dir" || exit 1

case "$ext" in
	tex) zathura "$base.pdf" & ;;
	md)
		sed -n '/^---$/,/^---$/p' "$file" | grep -qi "html: true" &&
			{ $BROWSER && kitty \
				--working-directory "$dir" \
				-- live-server "$base.html" & } ||
			{ zathura "$base.pdf" & }
		;;
	*) notify-send -a nvim "open.sh" "Can't find file to open." ;;
esac
