#!/usr/bin/fish

set -l sinks
set -l selectedSink
set -l selectedIndex

set -l i 1
for line in (pacmd list-sinks | grep "index");
	echo $line
	set -a sinks (echo $line | cut -d":" -f2 | cut -d" " -f2)
	if string match "*\**" $line;
		set selectedSink (echo $line | cut -d":" -f2 | cut -d" " -f2)
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
pacmd set-default-sink $switchToSink
