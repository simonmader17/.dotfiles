#!/usr/bin/env bash
randw=$(find "$WALLS" \
	-type f \
	-not -path "*\.git*" \
	-not -path "$WALLS/\!Handy/*" | shuf | head -1)
if file "$randw" | grep "image"; then
	~/scripts/pywal/set-wallpaper.sh "$randw" || command $0
else
	command $0
fi
