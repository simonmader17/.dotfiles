#!/usr/bin/env bash
# Based on: https://gist.github.com/jacksenechal/53dbf568438b212e7886b168ea4221c3
# 
# Usage: set this file as the post-processing script in the simple-scan preferences. No extra arguments needed.
# 
# Requirements:
# - simple-scan
# - ocrmypdf
# 
# For reference, at the time of writing the arguments from simple-scan are:
# $1    - the mime type, eg application/pdf
# $2    - boolean, keep original file
# $3    - the filename
# $4..N - postprocessing script arguments entered in preferences

log_file="$HOME/logs/simple-scan-ocr.log"
echo "--------------------------------------------------------------------------------" >>"$log_file"
echo "$(date -Iseconds): OCR started" >>"$log_file"
nid="$(notify-send -p -i scanner "OCR started...")"

filename=$3
ocrmypdf \
	-l deu \
	--deskew \
	--clean \
	--force-ocr \
	--keywords "OCR,OCRmyPDF" \
	"$filename" "$filename" &>>"$log_file"
if [ $? -ne 0 ]; then
  notify-send -r "$nid" -i scanner "OCR failed. See $log_file"
  exit 1
fi
action="$(notify-send -r "$nid" --action="OPEN=Open PDF" -i scanner "OCR complete")"
[ "$action" = "OPEN" ] && zathura "$filename" &
