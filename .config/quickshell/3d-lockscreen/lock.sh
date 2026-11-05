#!/usr/bin/env bash

# Locks the session unless the lockscreen is already running.
# The lock on fd 9 is inherited by quickshell through exec, so it is held
# exactly as long as the lockscreen runs and is released when it exits.
#
# By default the session is locked immediately (use this for hypridle).
# Pass --animate to slide the lockscreen in over the desktop first, e.g. from
# a keybind; the session is only locked once the slide ends (~0.5 s).

lockfile="${XDG_RUNTIME_DIR:-/tmp}/3d-lockscreen.lock"

exec 9> "$lockfile"
flock -n 9 || exit 0
if [[ "${1:-}" == "--animate" ]]; then
  export QS_LOCK_ANIMATE=1
fi

exec quickshell -c 3d-lockscreen
