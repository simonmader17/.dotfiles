#!/usr/bin/env bash

# This script toggles autocompilation for a document/file.
# I bind this to <leader>a in vim.

[[ -f "$1" ]] || exit 1
file="$(realpath -- "$1")"

pkill -f "entr -n $HOME/scripts/compile.sh $file" &&
	notify-send -a nvim "autocompile.sh" "Stopped auto compilation for \"$file\"" && exit
notify-send -a nvim "autocompile.sh" "Started auto compilation for \"$file\""
echo "$file" | entr -n ~/scripts/compile.sh "$file" >/dev/null 2>&1 &
