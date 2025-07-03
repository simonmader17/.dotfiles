#!/bin/bash
grep -v "^#" ~/.config/rofi/emoji.txt | grep "fully-qualified" | sed "s/.*# \(.*\)/\1/" | cut -d " " -f 1,3- | ~/.config/rofi/launch-dmenu.sh | cut -d " " -f 1 | wl-copy -n
