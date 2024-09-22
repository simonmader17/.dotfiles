#!/bin/bash

current_in=$(hyprctl getoption general:gaps_in | awk 'NR==1{print $3}')
current_out=$(hyprctl getoption general:gaps_out | awk 'NR==1{print $3}')

new_in=$(($current_in - 5))
new_out=$(($current_out - 5))

[ "$new_in" -lt 0 ] && new_in=0
[ "$new_out" -lt 0 ] && new_out=0

hyprctl --batch "keyword general:gaps_in $new_in"
hyprctl --batch "keyword general:gaps_out $new_out"
