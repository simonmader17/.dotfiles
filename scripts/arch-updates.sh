#!/usr/bin/env bash

updates_arch=$(checkupdates 2>/dev/null | wc -l) || updates_arch=0
updates_aur=$(paru -Qu --aur --quiet | wc -l) || updates_aur=0

updates=$(( "$updates_arch" + "$updates_aur" ))

jq -r -n --unbuffered --compact-output \
	--arg updates "$updates" \
	'{text: $updates, alt: $updates, tooltip: $updates, class: "", percentage: ""}'
