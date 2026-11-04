#!/usr/bin/env bash

# Focus a window by its Hyprland address without warping the cursor to it.
# cursor.no_warps is enabled only for this dispatch and restored afterwards.
# Requires Hyprland's Lua config provider (hyprctl eval).

addr=$1
[[ "$addr" == 0x* ]] || addr="0x$addr"
if [[ ! "$addr" =~ ^0x[0-9a-fA-F]+$ ]]; then
	exit 1
fi

hyprctl eval "
local old = hl.get_config('cursor.no_warps')
hl.config({ cursor = { no_warps = true } })
hl.dispatch(hl.dsp.focus({ window = 'address:$addr' }))
hl.config({ cursor = { no_warps = old } })
" > /dev/null
