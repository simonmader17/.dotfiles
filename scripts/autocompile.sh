#!/bin/bash

# This script toggles autocompilation for a document/file.
# I bind this to <leader>a in vim.

pkill -f "entr -n $HOME/scripts/compile.sh $1" &&
	notify-send -a nvim "autocompile.sh" "Stopped auto compilation for \"$1\"" && exit
notify-send -a nvim "autocompile.sh" "Started auto compilation for \"$1\""
echo "$1" | entr -n ~/scripts/compile.sh "$1" &
