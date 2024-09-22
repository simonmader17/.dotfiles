#!/bin/bash

# Copy this script to /lib/udev/
# &
# Add the following udev rules:
# SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="0",RUN+="/usr/bin/bash /lib/udev/picom_power_supply_switch.sh down"
# SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="1",RUN+="/usr/bin/bash /lib/udev/picom_power_supply_switch.sh up"

/usr/bin/killall picom;

if [ "$1" = "up" ]; then
	/usr/local/bin/picom -b --backend glx;
elif [ "$1" = "down" ]; then
	/usr/local/bin/picom -b --backend xrender;
fi
