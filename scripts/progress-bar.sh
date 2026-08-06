#!/usr/bin/env bash

# This is a universally usable script to produce a progress bar at the bottom of
# the screen.
#
# Usage:
# 1. Source the script at the beginning of your script.
# 2. Call `progress-bar` at the beginning of each loop iteration, and once after
# the loop finishes.

start="$SECONDS"
eta_prev=0

STATUS_TEXT="Processing"

usage-progress-bar() {
	echo "progress-bar [-s <STATUS_TEXT>] <current> <total>"
	exit 1
}

progress-bar() {
	local OPTARG OPTIND opt
	while getopts 's:' opt; do
		case "$opt" in
			s) STATUS_TEXT="$OPTARG" ;;
			*) usage-progress-bar ;;
		esac
	done
	shift $((OPTIND - 1))

	local current="$1"
	local total="$2"

	local now="$SECONDS"
	local time_diff="$(( now - start ))"
	local eta
	if (( time_diff == 0 || current <= 1 )); then
		eta='--:--:--'
	else
		local time_per_item time_remaining hours_remaining mins_remaining secs_remaining
		time_per_item="$(bc -l <<< "$time_diff / ($current - 1)")"
		time_remaining="$(bc -l <<< "$time_per_item * ($total - $current + 1)")"

		eta="$(bc -l <<< "($eta_prev + $time_remaining) / 2")"
		eta_prev="$eta"

		hours_remaining="$(bc -l <<< "$eta / 3600")"
		mins_remaining="$(bc -l <<< "$(bc <<< "$eta % 3600") / 60")"
		secs_remaining="$(bc <<< "$eta % 60")"
		eta="$(printf '%02.0f:%02.0f:%02.0f' "$hours_remaining" "$mins_remaining" "$secs_remaining")"
	fi

	local perc_done=$(( current * 100 / total ))

	local status=" $STATUS_TEXT $current/$total ($perc_done%) $eta ETA"
	local bar_length=$(( COLUMNS - ${#status} - 2 ))
	local num_bars=$(( perc_done * bar_length / 100 ))

	local i
	local bar='['
	for (( i=0; i < num_bars; i++ )); do
		bar+='#'
	done
	for (( i=num_bars; i < bar_length; i++ )); do
		bar+='.'
	done
	bar+=']'
	bar+="$status"

	printf '\e7' # save the cursor location
	printf '\e[%d;%dH' "$LINES" 0 # move cursor to the bottom line
	printf '\e[2K' # clear the line
	printf '%s' "$bar" # print the progress bar
	printf '\e8' # restore the cursor location
}

init-term() {
	printf '\n' # ensure there is enough space for the progress bar
	printf '\e7' # save the cursor location
	printf '\e[%d;%dr' 1 "$(( LINES - 1 ))" # set the scrollable region (margin)
	printf '\e8' # restore the cursor location
	printf '\e[1A' # move cursor up
}

deinit-term() {
	printf '\e7' # save the cursor location
	printf '\e[%d;%dr' 1 "$LINES" # reset the scrollable region (margin)
	printf '\e[%d;%dH' "$LINES" 0 # move cursor to the bottom line
	printf '\e[2K' # clear the line
	printf '\e8' # restore the cursor location
}

shopt -s checkwinsize
(:) # this line is to ensure LINES and COLUMNS are set

trap deinit-term exit
trap init-term winch
init-term
