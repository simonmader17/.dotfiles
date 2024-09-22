#!/bin/bash
default_in=$(grep "gaps_in = " ~/dotfiles/hypr/hyprland.conf | sed "s/.* = \(.*\)/\1/")
default_out=$(grep "gaps_out = " ~/dotfiles/hypr/hyprland.conf | sed "s/.* = \(.*\)/\1/")

hyprctl --batch "keyword general:gaps_in $default_in"
hyprctl --batch "keyword general:gaps_out $default_out"
