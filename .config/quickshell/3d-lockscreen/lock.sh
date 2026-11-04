#!/usr/bin/env bash

# Locks the session unless the lockscreen is already running.
# The lock on fd 9 is inherited by quickshell through exec, so it is held
# exactly as long as the lockscreen runs and is released when it exits.

lockfile="${XDG_RUNTIME_DIR:-/tmp}/3d-lockscreen.lock"

exec 9> "$lockfile"
flock -n 9 || exit 0
exec quickshell -c 3d-lockscreen
