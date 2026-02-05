#!/usr/bin/env bash

correct_thermal_zone_path="$(grep -lE 'pkg|cpu|soc' /sys/class/thermal/thermal_zone*/type | head -n1)"

if [[ -z "$correct_thermal_zone_path" ]]; then
	exit 1
fi
zone_dir="$(dirname "$correct_thermal_zone_path")"

read -r cpu_temp < "$zone_dir/temp"

printf "%s" "$(( cpu_temp / 1000 ))"
