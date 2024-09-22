#!/bin/bash

total_used=0
total_total=0

lsblk -o MOUNTPOINTS |
{
	while read line; do
		if [[ $line =~ ^/.*$ ]]; then
			out=$(df -h -BGiB "$line" | awk 'NR==2{print $3 " used out of " $2 " on " $6 " (" $5 ")"}')
			echo "$out"
	
			used=$(echo $out | awk '{print $1}' | numfmt --from=iec-i --suffix=B | tr -d -c 0-9)
	    total=$(echo $out | awk '{print $5}' | numfmt --from=iec-i --suffix=B | tr -d -c 0-9)
	    
	    total_used=$(( $total_used + $used ))
	    total_total=$(( $total_total + $total ))
		fi
	done
	
	total_used=$(numfmt --to=iec-i --suffix=B $total_used)
	total_total=$(numfmt --to=iec-i --suffix=B $total_total)
	echo "In total $total_used used out of $total_total"
}
