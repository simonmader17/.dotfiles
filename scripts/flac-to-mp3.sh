#!/usr/bin/env bash

# shellcheck source=progress-bar.sh
source "$HOME/scripts/progress-bar.sh"

usage() {
	cat << EOF
Usage: $0 [OPTION]... SOURCE_DIR DEST_DIR

Options
	-h	print usage message
	-c	clean/car compatible mode
	-n	perform a dry run with no changes made
EOF
}

mp3_bitrate=320

# ASCII-only, FAT-safe names. '/' stays allowed so this also works on paths.
sanitize() {
	printf '%s' "$1" | LC_ALL=C.UTF-8 iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null \
		| tr -c 'A-Za-z0-9._ ()/-' '_' | tr -s '_'
}

# Tags that car head units display. Everything else is dropped.
car_tags=(title artist album album_artist genre date track disc)

# Turn "Artist - Track (FLAC 24bit 1730 kbps).flac" into
#      "Artist - Track (MP3-320 320 kbps).mp3"
# Falls back to a plain extension swap when there is no such tag.
mp3_filename() {
	local base="${1%.*}"
	shopt -s nocasematch
	if [[ "$base" =~ ^(.*)\(FLAC[^\)]*kbps\)(.*)$ ]]; then
		base="${BASH_REMATCH[1]}(MP3-${mp3_bitrate} ${mp3_bitrate} kbps)${BASH_REMATCH[2]}"
	fi
	printf '%s.mp3' "$base"
}

car_compatible=false
dry_run=false
while getopts 'hcn' opt; do
	case "$opt" in
		h) usage; exit 0;;
		c) car_compatible=true;;
		n) dry_run=true;;
		*) usage >&2; exit 1;;
	esac
done
shift $(( OPTIND - 1 ))

if (( $# != 2 )); then
	usage
	exit 1
fi

source="$1"
dest="$2"

if [[ ! -d "$source" ]]; then
	echo "Error: source directory '$source' does not exist!"
	exit 1
fi

mkdir -p "$dest"

max_jobs=$(( $(nproc) - 0 ))
pids=()

echo "Finding files..."
readarray -d '' files < <(find "$source" -type f -print0)
len="${#files[@]}"
echo "Found $len files."

i=0
converted=0
copied=0
failed_converted=0
failed_copied=0
skipped=0
for file in "${files[@]}"; do
	progress-bar "$(( ++i ))"	"$len"

	rel_path="${file#"$source"/}"
	dir_path="$(dirname "$rel_path")"
	filename="$(basename "$file")"
	extension="${filename##*.}"

# 	cat << EOF
# File: $file
# 	rel_path: $rel_path
# 	dir_path: $dir_path
# 	filename: $file
# 	extension: $extension
# EOF

	$car_compatible && dir_path="$(sanitize "$dir_path")"

	mkdir -p "$dest/$dir_path"
	if [[ "$extension" == "flac" ]]; then
		out_name="$(mp3_filename "$filename")"
		$car_compatible && out_name="$(sanitize "$out_name")"
		out_file="$dest/$dir_path/$out_name"
		if [[ -f "$out_file" ]]; then
			echo "Skipping (already exists): $file"
			(( skipped++ ))
			continue
		fi

		echo "Converting: $file -> $out_file"

		while (( ${#pids[@]} >= max_jobs )); do
			wait -n
			for idx in "${!pids[@]}"; do
				if ! kill -0 "${pids[idx]}" 2>/dev/null; then
					# Check if ffmpeg execution was successful
					if wait "${pids[idx]}"; then (( converted++ )) else (( failed_converted++ )) fi
					# Remove pid from array
					unset "pids[idx]"
				fi
			done
		done

		if ! $dry_run; then
			ff_args=(-map_metadata 0)
			if $car_compatible; then
				# 500x500 JPEG cover, whitelisted tags only
				ff_args=(
					-map 0:a
					-map "0:v?"
					-c:v mjpeg
					-vf scale=500:500
					-disposition:v attached_pic
					-map_metadata -1
				)
				for key in "${car_tags[@]}"; do
					value="$(ffprobe -v error -show_entries "format_tags=$key" \
						-of default=nw=1:nk=1 "$file")"
					[[ -n "$value" ]] && ff_args+=(-metadata "$key=$value")
				done
			fi
			ffmpeg -i "$file" \
				-ab "${mp3_bitrate}k" \
				"${ff_args[@]}" \
				-id3v2_version 3 \
				-nostdin \
				-loglevel error \
				-y "$out_file" &
			pids+=($!)
		else
			(( converted++ ))
		fi
	else
		$car_compatible && continue
		out_file="$dest/$dir_path/$filename"
		if [[ -f "$out_file" ]]; then
			echo "Skipping (already exists): $file"
			(( skipped++ ))
			continue
		fi

		echo "Copying: $file -> $out_file"
		if ! $dry_run; then
			if cp "$file" "$out_file"; then (( copied++ )) else (( failed_copied++ )) fi
		else
			(( copied++ ))
		fi
	fi
done

for pid in "${pids[@]}"; do
	if wait "$pid"; then (( converted++ )) else (( failed_converted++ )) fi
done

progress-bar "$len" "$len"

cat << EOF
Processing of $len files complete!
	Converted: $converted
	Copied: $copied
	Failed conversions: $failed_converted
	Failed copies: $failed_copied
	Skipped: $skipped
EOF
