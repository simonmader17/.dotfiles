#!/usr/bin/env bash

# Applies ocr to an already existing PDF file.
#
# Requirements:
# - ocrmypdf
#
# Arguments:
# $1 - filename of the already existing PDF file

[ -z "$1" ] && echo "filename missing" && exit 1
filename="$1"

log_file="$HOME/logs/my-ocr.log"
echo "--------------------------------------------------------------------------------" >>"$log_file"
echo "$(date -Iseconds): OCR started" >>"$log_file"
nid="$(notify-send -p -i scanner "OCR started...")"

mkdir /tmp/my-ocr
cp "$filename" /tmp/my-ocr/"$filename" # Backup original file to /tmp/my-ocr/ directory

ocrmypdf \
	-l deu \
	--deskew \
	--clean \
	--force-ocr \
	--keywords OCR,OCRmyPDF \
	"$filename" "$filename" 2>&1 | tee -a "$log_file"
if [ $? -ne 0 ]; then
  notify-send -r "$nid" -i scanner "OCR failed. See $log_file"
  exit 1
fi
action="$(notify-send -r "$nid" --action="OPEN=Open PDF" -i scanner "OCR complete")"
[ "$action" = "OPEN" ] && zathura "$filename" &
