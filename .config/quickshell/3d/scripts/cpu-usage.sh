#!/usr/bin/env bash

if [[ ! -f /proc/stat ]]; then
	echo "No cpu stats found. Does /proc/stat exist?"
	exit 1
fi
read -r _ user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

old_file="/dev/shm/old-cpu-usage"
if [[ ! -f "$old_file" ]]; then
	echo "$user $nice $system $idle $iowait $irq $softirq $steal $guest $guest_nice" > "$old_file"
fi

read -r old_user old_nice old_system old_idle old_iowait old_irq old_softirq old_steal old_guest old_guest_nice < "$old_file"
echo "$user $nice $system $idle $iowait $irq $softirq $steal $guest $guest_nice" > "$old_file"

old_total_idle=$(( old_idle + old_iowait ))
old_total=$(( old_user + old_nice + old_system + old_idle + old_iowait + old_irq + old_softirq + old_steal + old_guest + old_guest_nice ))
total_idle=$(( idle + iowait ))
total=$(( user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice ))

diff_total_idle=$(( total_idle - old_total_idle ))
diff_total=$(( total - old_total ))
if (( diff_total == 0 )); then
	exit 1
else
	cpu_usage=$(( 100 * (diff_total - diff_total_idle) / diff_total ))
	printf "%s" "$cpu_usage"
fi
