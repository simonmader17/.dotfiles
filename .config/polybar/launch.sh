#!/bin/bash
# My polybar launch script.

sleep 1 # wait a sec

# Terminate already running bar instances and wait until the processes have
# been shut down
killall -qvw polybar polybar-msg

sleep 1 # wait a sec

# Setup my-network current file
echo "<Show IP>" > ~/.config/polybar/my-network/current

primary=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
others=$(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1)
monitors=(${primary[@]} ${others[@]})
echo ${monitors[@]}

largeMonitorExists=false

if type "xrandr"; then
	# Check if large monitor exists
	for m in ${monitors[@]}; do
		if [[ "$(xrandr --query | grep $m)" == *"2560x1440"* ]]; then
			largeMonitorExists=true
		fi
	done
	for m in ${monitors[@]}; do
		if [[ "$(xrandr --query | grep $m)" == *"2560x1440"* ]]; then
			MONITOR=$m polybar --reload top &
		else
			MONITOR=$m polybar --reload top-small &
			# if [ "$largeMonitorExists" = false ]; then
				MONITOR=$m polybar --reload bottom-small &
			# fi
		fi
		if [[ "$m" == "$primary" ]]; then
			sleep 1 # Wait for primary monitor to grab the tray
		fi
	done
else
	polybar --reload top &
fi
