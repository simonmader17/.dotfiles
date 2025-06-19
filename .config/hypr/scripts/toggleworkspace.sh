#!/usr/bin/env bash

usage() {
	echo "Usage:"
	echo "    $0 <workspace-id>"
	echo "    $0 name:<workspace-name>"
	exit 1
}

if (( $# != 1 )); then
	usage
fi

target="$1"

current_workspace="$(hyprctl activeworkspace -j)"
current_id="$(jq -r '.id' <<< "$current_workspace")"
current_name="$(jq -r '.name' <<< "$current_workspace")"

if [[ "$target" =~ ^[0-9]+$ ]]; then
	if [[ "$current_id" == "$target" ]]; then
		hyprctl dispatch workspace previous_per_monitor
	else
		hyprctl dispatch workspace "$target"
	fi
elif [[ "$target" =~ ^name:.+$ ]]; then
	if [[ "$current_name" == "${target#name:}" ]]; then
		hyprctl dispatch workspace previous_per_monitor
	else
		hyprctl dispatch workspace "$target"
	fi
else
	usage
fi
