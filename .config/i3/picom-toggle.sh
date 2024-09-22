#!/bin/bash
if pgrep -x "picom" > /dev/null
then
	killall picom
else
	bash ~/.config/picom/start-picom.sh
fi
