#!/bin/bash

if [[ $(nordvpn status | grep "Status: Disconnected") ]]
then
	echo "<Connect to VPN>"
else
	# nordvpn status | grep "Status: Connected" -A4 | grep "IP" | cut -d " " -f 2
	ip=$(nordvpn status | grep -P '^IP' | cut -d " " -f 2)
	country=$(nordvpn status | grep -P '^Country' | cut -d " " -f 2-)
	echo "$ip ($country)"
fi
