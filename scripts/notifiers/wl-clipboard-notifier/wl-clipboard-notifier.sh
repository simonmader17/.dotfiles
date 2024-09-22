#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PATH="$SCRIPT_DIR:$PATH"

cleanup() {
	echo "Killing background processes..."
	kill $PID_TEXT $PID_IMAGE
	exit 0
}

trap cleanup SIGINT SIGTERM

wl-paste --type text/plain --watch wl-clipboard-text-notification.sh &
PID_TEXT=$!
echo "Text PID: $PID_TEXT"

wl-paste --type image/png --watch wl-clipboard-image-notification.sh &
PID_IMAGE=$!
echo "Image PID: $PID_IMAGE"

wait $PID_TEXT $PID_IMAGE
