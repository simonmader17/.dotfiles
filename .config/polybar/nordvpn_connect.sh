#!/bin/bash

status=$(nordvpn status | grep "Status")

if [[ $status == *"Connected"* ]]
then
	command nordvpn disconnect
elif [[ $status == *"Disconnected"* ]]
then
	command nordvpn connect United_States
fi
