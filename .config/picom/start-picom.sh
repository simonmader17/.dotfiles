killall picom;
if lshw -C display | grep "NVIDIA"; then
	picom -b --backend glx --config ~/.config/picom/high-battery-usage.conf;
else
	picom -b --backend xrender --config ~/.config/picom/low-battery-usage.conf;
fi
