#!/usr/bin/env bash

usage() {
	echo "Usage: $0 {grow|shrink|reset}" >&2
}

get_default() {
	[[ -z "$1" ]] && return 1
	local conf_files=( "$HOME/.config/hypr/hyprland.conf" )
	if [[ -f "$HOME/.config/hypr/hyprland-overrides.conf" ]]; then
		conf_files+=( "$HOME/.config/hypr/hyprland-overrides.conf" )
	fi
	local ret=""
	local f
	for f in "${conf_files[@]}"; do
		while IFS='=' read -r key value; do
			key="${key//[[:blank:]]/}"
			[[ "$key" == "$1" ]] && ret="${value//[[:blank:]]/}"
		done < "$f"
	done
	[[ -z "$ret" ]] && return 1
	echo "$ret"
	return 0
}

get_current() {
	[[ -z "$1" ]] && return 1
	IFS=':' read -r _ value < <(hyprctl getoption "$1")
	read -r value _ <<< "$value"
	[[ -z "$value" ]] && return 1
	echo "$value"
	return 0
}

while getopts '' opt; do
	case "$opt" in
		*) usage; exit 1;;
	esac
done
[[ -z "$1" || -n "$2" ]] && usage && exit 1

batch_commands=()
case "$1" in
	grow)
		current_in="$(get_current "general:gaps_in")"
		current_out="$(get_current "general:gaps_out")"
		if (( current_in == 0 )) && (( current_out == 0 )); then
			batch_commands+=("keyword decoration:rounding $(get_default "rounding")")
		fi
		new_in=$(( current_in + 5 ))
		new_out=$(( current_out + 5 ))
		(( new_in > 100 )) && new_in=100
		(( new_out > 100 )) && new_out=100
		batch_commands+=("keyword general:gaps_in $new_in")
		batch_commands+=("keyword general:gaps_out $new_out")
		IFS=';'
		hyprctl --batch "${batch_commands[*]}"
		;;
	shrink)
		current_in="$(get_current "general:gaps_in")"
		current_out="$(get_current "general:gaps_out")"
		new_in=$(( current_in - 5 ))
		new_out=$(( current_out - 5 ))
		(( new_in < 0 )) && new_in=0
		(( new_out < 0 )) && new_out=0
		if (( new_in == 0 )) && (( new_out == 0 )); then
			batch_commands+=("keyword decoration:rounding 0")
		fi
		batch_commands+=("keyword general:gaps_in $new_in")
		batch_commands+=("keyword general:gaps_out $new_out")
		IFS=';'
		hyprctl --batch "${batch_commands[*]}"
		;;
	reset)
		batch_commands+=("keyword decoration:rounding $(get_default "rounding")")
		batch_commands+=("keyword general:gaps_in $(get_default "gaps_in")")
		batch_commands+=("keyword general:gaps_out $(get_default "gaps_out")")
		IFS=';'
		hyprctl --batch "${batch_commands[*]}"
		;;
	*) usage; exit 1;;
esac
