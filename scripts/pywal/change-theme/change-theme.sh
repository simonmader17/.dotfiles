#!/usr/bin/env bash

if [ -z $1 ]; then
	theme_name=default
else
	theme_name=$1
fi

theme_path="$HOME/scripts/pywal/themes/$theme_name.json"
if [ ! -f "$theme_path" ]; then
	echo "Theme \"$theme_name\" doesn't exist." >&2
	exit 2
fi

wal --theme "$theme_path" -o "$HOME/scripts/pywal/post-pywal.sh"
