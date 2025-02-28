#!/usr/bin/env bash
# ffplay -window_title "Webcam" -fast /dev/video0
mpv --geometry=-0-0 --autofit=30% --no-osc --no-input-default-bindings --input-conf=/dev/null /dev/video0
