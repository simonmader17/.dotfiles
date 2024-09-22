#!/usr/bin/fish

set -l sinks
set -l selectedSink
set -l selectedIndex

set -l i 1
for line in (pactl list short sinks);
	echo $line
	set -a sinks (echo $line | cut -f 1)
	if string match "*RUNNING*" $line;
		set selectedSink (echo $line | cut -f 1)
		set selectedIndex $i
	end
	set -l i (math $i+1)
end

echo $sinks
echo $selectedSink
set -l sinksCount (count $sinks)

set -l switchToSink
if [ $selectedIndex -eq $sinksCount ];
	set switchToSink $sinks[1]
else;
	set switchToSink $sinks[(math $selectedIndex+1)]
end

echo $switchToSink
pactl set-default-sink $switchToSink
