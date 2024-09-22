#!/bin/bash
# grep -v "^#" ~/.config/rofi/emoji-data.txt | grep "emoji" | sed "s/.*(\(.*\)) \(.*\)/\1: \2/" | tr "[:upper:]" "[:lower:]" | ~/.config/rofi/launch-dmenu.sh | cut -d ":" -f 1 | wl-copy -n
grep -v "^#" ~/.config/rofi/emoji-test.txt | grep "fully-qualified" | sed "s/.*# \(.*\)/\1/" | cut -d " " -f 1,3- | ~/.config/rofi/launch-dmenu.sh | cut -d " " -f 1 | wl-copy -n
