#!/usr/bin/env bash
#
# Scans all pages double-sided from a HP document feeder and applies OCR to them.
#
# Requirements:
# - sane (scanimage)
# - imagemagick (convert)

device_uri="$SCANNER_URI"
tmp_folder='/tmp/hp-document-feeder-scan'
output_file="$HOME/Documents/$(date -Iseconds)_Duplex_Scan.pdf"

## hp-scan does not work (takes forever using 300 dpi)
# hp-scan \
# 	--device="$device_uri" \
# 	--mode='color' \
# 	--resolution=300 \
# 	--size=a4 \
# 	--duplex \
# 	--output="$output_file" \
# 	--compression=jpeg

mkdir -p "$tmp_folder"
rm -f "$tmp_folder"/page_*.jpg

pages=0
scanning=true
while $scanning; do
	scanimage \
		-d "$device_uri" \
		--format=jpeg \
		--batch="$tmp_folder/page_%d.jpg" \
		--batch-start=$(( pages + 1 )) \
		-p \
		-v \
		--mode Color \
		--source Duplex \
		--resolution 300 \
		-l0 -t10 -x210 -y277
	# Had to reduce the 👆height here from 297 to 277, because the program would
	# throw an error "transferred too few scanlines" with the bigger height. The
	# error is discussed here: https://github.com/sbs20/scanservjs/issues/406
	status=$?
	if (( $status == 0 )); then
		convert $(ls -v "$tmp_folder"/page_*.jpg) "$output_file" &&
			~/scripts/my-ocr.sh "$output_file"
		scanning=false
	elif (( $status == 1 )); then
		# Error while scanning
		pages="$(ls "$tmp_folder"/page_*.jpg | wc -l)"
		if (( pages % 2 == 1 )); then
			# Only consider fully scanned pieces of paper
			(( pages-- ))
		fi
		echo "🤕 Oops! Looks like something went wrong while scanning the document."
		echo
		echo "Check the scanner for stuck pages! $pages pages have been scanned successfully so far."
		echo
		while true; do
			read -p "If you are ready, press Y to continue with the scanning of the document, or press N do abort [Y/N]:" yn
			case $yn in
				[Yy]*)
					break
					;;
				[Nn]*)
					scanning=false
					break
					;;
			esac
		done
	else
		scanning=false
	fi
done
