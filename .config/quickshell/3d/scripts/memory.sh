#!/usr/bin/env bash

if [[ ! -f /proc/meminfo ]]; then
	echo "No memory stats found. Does /proc/meminfo exist?"
	exit 1
fi

while IFS=':' read -r key value; do
	case "$key" in
		MemTotal)
			mem_total=${value%%kB*}
			mem_total=${mem_total## }
			;;
		MemAvailable)
			mem_avail=${value%%kB*}
			mem_avail=${mem_avail## }
			;;
	esac
done < /proc/meminfo
mem_used=$(( mem_total - mem_avail ))

mem_used_GiB="$(bc <<< "scale=1; $mem_used / 1024 / 1024")"
mem_total_GiB="$(bc <<< "scale=1; $mem_total / 1024 / 1024")"

echo -n "$(( 100 * mem_used / mem_total ));${mem_used_GiB};${mem_total_GiB}"
