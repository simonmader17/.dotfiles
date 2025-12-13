#!/usr/bin/env bash

usage() {
	echo "Usage: $0 [-h] [-V VPN_NAME] [GIT_ARGS]"
}

while getopts 'hV:' opt; do
	case "$opt" in
		h) usage; exit 0;;
		V) vpn_name="${OPTARG}";;
		*) usage >&2; exit 1;;
	esac
done
shift $((OPTIND-1))
if [[ -z "$vpn_name" ]]; then
	usage
	exit 1
fi

if ! nmcli connection show --active | grep -q "$vpn_name"; then
	NEEDS_DISCONNECT=true
	nmcli connection up "$vpn_name"
fi

git "$@"

if $NEEDS_DISCONNECT; then
	nmcli connection down "$vpn_name"
fi
