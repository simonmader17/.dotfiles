#!/usr/bin/env bash

supply='/sys/class/power_supply'

if [[ ! -d "$supply" ]]; then
	exit 1
fi

ac_online=0
batteries=()

for dev in "$supply"/*; do
	if [[ ! -r "$dev/type" ]]; then
		continue
	fi
	read -r dev_type < "$dev/type"
	case "$dev_type" in
		Mains)
			if [[ ! -r "$dev/online" ]]; then
				continue
			fi
			read -r online < "$dev/online"
			(( online )) && ac_online=1
			;;
		Battery)
			batteries+=("$dev")
			;;
	esac
done

if (( ${#batteries[@]} == 0 )); then
	exit 1
fi

# First line: AC status, one line per battery afterwards
printf '%d' "$ac_online"

for bat in "${batteries[@]}"; do
	read -r capacity < "$bat/capacity"
	read -r status < "$bat/status"
	read -r power_now < "$bat/power_now"
	read -r energy_now < "$bat/energy_now"
	read -r energy_full < "$bat/energy_full"
	read -r energy_full_design < "$bat/energy_full_design"
	read -r voltage_now < "$bat/voltage_now"
	read -r voltage_min_design < "$bat/voltage_min_design"
	read -r manufacturer < "$bat/manufacturer"
	read -r model_name < "$bat/model_name"

	printf '\n%d;%s;%d;%d;%d;%d;%d;%d;%s;%s' "$capacity" "$status" "$power_now" "$energy_now" "$energy_full" "$energy_full_design" "$voltage_now" "$voltage_min_design" "$manufacturer" "$model_name"
done
