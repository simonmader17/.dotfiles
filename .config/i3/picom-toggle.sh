#!/bin/bash
if pgrep -x "picom" > /dev/null
then
	killall picom
else
	bash ~/dotfiles/picom/start-picom.sh
fi
