#!/bin/bash
while ! lsof /tmp/ckbpipe000 || ! lsof /tmp/ckbpipe001; do
	echo "Could not set ckb-next color."
	echo "Is ckb-next running? Trying again in 2 seconds..."
	sleep 2
done
MAIN_COLOR="$(cat ~/.cache/wal/colors.json | jq ".colors.color1" -r)"
ACCENT_COLOR="$(cat ~/.cache/wal/colors.json | jq ".colors.color2" -r)"
echo "rgb ${MAIN_COLOR//\#}ff" > /tmp/ckbpipe000
echo "rgb ${ACCENT_COLOR//\#}ff" > /tmp/ckbpipe001
