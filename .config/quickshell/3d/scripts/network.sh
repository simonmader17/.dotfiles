#!/usr/bin/env bash

human_readable_size() {
	local bytes="$1"
	local units=("B" "kB" "MB" "GB" "TB")
	local i=0

	while (( "$(bc <<< "$bytes > 1000")" )) && (( i < ${#units[@]} - 1 )); do
		bytes="$(bc <<< "scale=2; $bytes / 1000")"
		(( i++ ))
	done

	if (( i == 0 )); then
		printf "%d%s" "$bytes" "${units[$i]}"
	else
		printf "%.1f%s" "$bytes" "${units[$i]}"
	fi
}

if [[ ! -f /proc/net/route ]]; then
	exit 1
fi

while read -r iface dest _; do
	if [[ "$dest" == "00000000" ]]; then
		break
	fi
done < /proc/net/route
if [[ "$iface" == "w"* ]]; then
	while read -r wl_iface _ wl_quality _; do
		if [[ "${wl_iface%:}" == "$iface" ]]; then
			quality="${wl_quality%.}"
			quality=$(( quality * 100 / 70 )) # scale to 0 to 100 range
		fi
	done < /proc/net/wireless
else
	quality="-1"
fi

stats="/sys/class/net/$iface/statistics"
if [[ ! -d "$stats" ]]; then
	exit 1
fi
read -r rx < "$stats/rx_bytes"
read -r tx < "$stats/tx_bytes"
time="$(date +%s)"

old_file="/dev/shm/old-net-speed-$iface"
if [[ ! -f "$old_file" ]]; then
	echo "$time $rx $tx" > "$old_file"
fi

read -r old_time old_rx old_tx < "$old_file"
echo "$time $rx $tx" > "$old_file"

time_diff=$(( time - old_time ))
if (( time_diff <= 0 )); then
	exit 1
fi

rx_diff=$(( rx - old_rx ))
tx_diff=$(( tx - old_tx ))
rx_rate=$(( rx_diff / time_diff ))
tx_rate=$(( tx_diff / time_diff ))

printf "%s;%s;%s;%s;%s;%d" \
	"$iface" \
	"$(human_readable_size "$rx_rate")/s" \
	"$(human_readable_size "$rx")" \
	"$(human_readable_size "$tx_rate")/s" \
	"$(human_readable_size "$tx")" \
	"$quality"
