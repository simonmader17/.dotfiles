#!/bin/bash

# This script toggles autocompilation for a document/file.
# I bind this to <leader>a in vim.

pkill -f "entr -n $HOME/scripts/compile.sh" &&
	notify-send -a nvim "autocompile.sh" "Stopped auto compilation" && exit
notify-send -a nvim "autocompile.sh" "Started auto compilation"
echo "$1" | entr -n ~/scripts/compile.sh "$1" &
