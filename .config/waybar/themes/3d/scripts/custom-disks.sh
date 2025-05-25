#!/usr/bin/env bash

# waybar custom module expects: $test\n$tooltip\n$class

# First line: $text
echo -ne "\n"

# Second line: $tooltip
critical_threshold=92
critical=false # flag for the $class in the third line
while read -r line; do
	if [[ "$line" =~ ^In\ total.*$ ]]; then
		# Last line of tooltip
		echo -ne "$line\n"
	else
		# removes everything up to '('
		percentage_used="${line##*(}"
		# removes everything from '%)' onwards
		percentage_used="${percentage_used%%%)*}"

		if ((percentage_used >= critical_threshold)); then
			critical=true
			echo -ne "<span color='#ff6666'>$line</span>\r"
		else
			echo -ne "$line\r"
		fi
	fi
done < <(~/scripts/my-disks.sh)

# Third line
if $critical; then
	echo -ne "critical\n"
else
	echo -ne "\n"
fi
