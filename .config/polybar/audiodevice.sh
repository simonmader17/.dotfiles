#!/bin/bash

# pacmd list-sinks | grep "* index" -A1 | grep "name" | cut -d "." -f 2 | cut -c 1-10 | awk '{print $1"..."}'
# pacmd list-sinks | grep "* index" -A70 | grep "alsa.long_card_name" | cut -d "\"" -f 2 | cut -c 1-13 | awk '{print $0"..."}'
# pactl list sinks | grep "State: RUNNING" -A70 | grep "alsa.long_card_name" | cut -d "\"" -f 2 | cut -c 1-13 | awk '{print $0"..."}'
# pactl list short sinks | grep "RUNNING" | cut -f2 | cut -c 13-26 | awk '{print $0"..."}'
# echo "$(pactl list sinks | grep "State: RUNNING" -A70 | grep "device.profile.description" | cut -d "\"" -f 2) - $(pactl list sinks | grep "State: RUNNING" -A70 | grep "alsa.card_name" | cut -d "\"" -f 2)" | sed "s/\(.\{20\}\).*/\1.../"
# pactl list sinks | grep "RUNNING" -A70 | grep "Description" | cut -d " " -f 2- | sed "s/\(.\{21\}\).*/\1.../"
pactl list sinks | grep "$(pactl get-default-sink)" -A70 | grep -m 1 "Description" | cut -d " " -f 2- | sed "s/\(.\{21\}\).*/\1.../"
