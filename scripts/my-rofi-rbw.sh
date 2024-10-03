#!/bin/bash

rbw unlock && rbw ls --fields name,user,folder \
	| sort \
	| awk -F'\t' '{print $1 "\t(" $2 ")\t[" $3 "]"}' \
	| ~/.config/rofi/launch-dmenu.sh \
	| awk -F'\t' '{ $2 = substr($2, 2, length($2) - 2); printf "\"" $1 "\""; if ($2 != "") print " \"" $2 "\""; else print ""}' \
	| xargs -r rbw get 2>&1 \
	| wl-copy -n
