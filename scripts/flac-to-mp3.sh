#!/usr/bin/env bash

source ~/scripts/progress-bar.sh

if (( $# != 2 )); then
	echo "Usage: $0 <source> <dest>"
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

	# cat <<- EOF
	# File: $file
	# 	rel_path: $rel_path
	# 	dir_path: $dir_path
	# 	filename: $file
	# 	extension: $extension
	# EOF

	mkdir -p "$dest/$dir_path"
	if [[ "$extension" == "flac" ]]; then
		out_file="$dest/$dir_path/${filename%.*}.mp3"
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

		ffmpeg -i "$file" -ab 192k -map_metadata 0 -id3v2_version 3 -nostdin -loglevel error -y "$out_file" &
		pids+=($!)
	else
		out_file="$dest/$dir_path/$filename"
		if [[ -f "$out_file" ]]; then
			echo "Skipping (already exists): $file"
			(( skipped++ ))
			continue
		fi

		echo "Copying: $file -> $out_file"
		if cp "$file" "$out_file"; then (( copied++ )) else (( failed_copied++ )) fi
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
