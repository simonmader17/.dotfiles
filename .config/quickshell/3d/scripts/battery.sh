#!/usr/bin/env bash

bat0='/sys/class/power_supply/BAT0'
ac='/sys/class/power_supply/AC'

if [[ ! -d "$bat0" || ! -d "$ac" ]]; then
	exit 1
fi

read -r capacity < "$bat0/capacity"
read -r status < "$bat0/status"
read -r ac_online < "$ac/online"
read -r power_now < "$bat0/power_now"
read -r energy_now < "$bat0/energy_now"
read -r energy_full < "$bat0/energy_full"
read -r energy_full_design < "$bat0/energy_full_design"
read -r voltage_now < "$bat0/voltage_now"
read -r voltage_min_design < "$bat0/voltage_min_design"
read -r manufacturer < "$bat0/manufacturer"
read -r model_name < "$bat0/model_name"

printf "%d;%s;%d;%d;%d;%d;%d;%d;%d;%s;%s" "$capacity" "$status" "$ac_online" "$power_now" "$energy_now" "$energy_full" "$energy_full_design" "$voltage_now" "$voltage_min_design" "$manufacturer" "$model_name"
