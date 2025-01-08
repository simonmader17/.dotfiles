#!/bin/bash
# waybar custom module expects: $test\n$tooltip\n$class

critical_threshold=95
critical=false

# First line: $text
echo -n -e "\n"

# Second line: $tooltip
~/scripts/my-disks.sh |
{
	while read line; do
		if [[ "$line" =~ ^In\ total.*$ ]]; then
			# Last line of tooltip
			echo -n -e "$line\n"
		else
			percentage_used=$(echo $line | grep -oP '\(\K[0-9]+(?=%)')
			if [ $percentage_used -ge $critical_threshold ]; then
				critical=true
				echo -n -e "<span color='#ff6666'>$line</span>\r"
			else
				echo -n -e "$line\r"
			fi
		fi
	done

	# Third line
	if [[ "$critical" == true ]]; then
		echo -n -e "critical\n"
	else
		echo -n -e "\n"
	fi
}
