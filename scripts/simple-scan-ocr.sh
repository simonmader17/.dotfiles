#!/usr/bin/env bash
# Based on: https://gist.github.com/jacksenechal/53dbf568438b212e7886b168ea4221c3
# 
# Usage: set this file as the post-processing script in the simple-scan preferences. No extra arguments needed.
# 
# For reference, at the time of writing the arguments from simple-scan are:
# $1    - the mime type, eg application/pdf
# $2    - boolean, keep original file
# $3    - the filename
# $4..N - postprocessing script arguments entered in preferences

log_file="$HOME/logs/simple-scan-ocr.log"
echo "--------------------------------------------------------------------------------" >>"$log_file"
echo "$(date -Iseconds): OCR started" >>"$log_file"

filename=$3
echo "Executing ~/scripts/my-ocr.sh \"$filename\"" >>"$log_file"
~/scripts/my-ocr.sh "$filename" &>>"$log_file"
