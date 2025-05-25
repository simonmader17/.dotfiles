#!/usr/bin/env bash

# Prints the disk usage for mounted filesystems. It shows used and total space
# per mount point and optionally calculates the total usage across all
# filesystems.
#
# Dependencies:
# - lsblk
# - sort
# - numfmt (optional)

used=0
total=0

calc=false
if command -v numfmt &>/dev/null; then
	calc=true
fi

while IFS=' ' read -r mountpoint fsused fssize fspercentage; do
	if [[ "$mountpoint" =~ ^/.*$ ]]; then
		echo "$mountpoint: $fsused used out of $fssize ($fspercentage)"
		if $calc; then
			fsused_bytes="$(numfmt --from=iec "$fsused")"
			fssize_bytes="$(numfmt --from=iec "$fssize")"
			((used += fsused_bytes))
			((total += fssize_bytes))
		fi
	fi
done < <(lsblk -o 'MOUNTPOINT,FSUSED,FSSIZE,FSUSE%' | sort)

if $calc; then
	used="$(numfmt --to=iec "$used")"
	total="$(numfmt --to=iec "$total")"
	echo "In total $used used out of $total"
fi
