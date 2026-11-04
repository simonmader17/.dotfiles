#!/usr/bin/env bash

# Prints the Hyprland options the bar depends on as
# <animations enabled (1/0)>;<border size>;<blur enabled (1/0)>;<blur size>;<blur passes>
# Polled every 100 ms while a workspace preview is open, so it makes a single
# hyprctl call and parses in bash.

output=$(hyprctl --batch "getoption animations:enabled; getoption general:border_size; getoption decoration:blur:enabled; getoption decoration:blur:size; getoption decoration:blur:passes" 2> /dev/null) || exit 1

values=()
while read -r line; do
	if [[ "$line" =~ ^(bool|int):\ (.+)$ ]]; then
		case "${BASH_REMATCH[2]}" in
			true) values+=(1) ;;
			false) values+=(0) ;;
			*) values+=("${BASH_REMATCH[2]}") ;;
		esac
	fi
done <<< "$output"

[[ ${#values[@]} -eq 5 ]] || exit 1
for value in "${values[@]}"; do
	[[ "$value" =~ ^[0-9]+$ ]] || exit 1
done
[[ "${values[0]}" =~ ^[01]$ && "${values[2]}" =~ ^[01]$ ]] || exit 1

IFS=";"
echo "${values[*]}"
