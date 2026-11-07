#!/usr/bin/env bash

# Applies ocr to an already existing PDF file.
#
# Requirements:
# - ocrmypdf
# - tesseract-data-deu
#
# Arguments:
# $1 - filename of the already existing PDF file

if [[ -z "$1" ]]; then
	echo "Usage: $0 FILE" >&2
	exit 1
fi
filename="$1"

if [[ ! -f "$filename" ]]; then
	echo "No such file: $filename" >&2
	exit 1
fi
mime="$(file --mime-type -b -- "$filename")"
if [[ "$mime" != "application/pdf" ]]; then
	echo "Not a PDF file: $filename" >&2
	exit 1
fi

log_file="$HOME/logs/my-ocr.log"
mkdir -p "$(dirname "$log_file")"
echo "--------------------------------------------------------------------------------" >>"$log_file"
echo "$(date -Iseconds): Applying OCR to \"$filename\"" >>"$log_file"
nid="$(notify-send -p -t 100000 -i scanner "Performing OCR...")"

# Backup original file to /tmp/my-ocr/ directory
tmp_file='/tmp/my-ocr'
rm -rf "$tmp_file"; mkdir "$tmp_file"
cp "$filename" "$tmp_file"/"$(date -Iseconds)"_"$(basename "$filename")" || { notify-send -r "$nid" -i scanner "Backup failed, aborting"; exit 1; }

ocrmypdf \
	-l deu \
	--rotate-pages \
	--rotate-pages-threshold 5 \
	--deskew \
	--clean \
	--force-ocr \
	--keywords OCR,OCRmyPDF \
	"$filename" "$filename" 2>&1 | tee -a "$log_file"
rc=${PIPESTATUS[0]}
if (( rc != 0 )); then
	notify-send -r "$nid" -i scanner "OCR failed. See $log_file"
	exit 1
fi
{
	action="$(notify-send -r "$nid" --action="OPEN=Open PDF" -i scanner "OCR complete")"
	[[ "$action" == "OPEN" ]] && zathura "$filename" &>/dev/null &
} &
