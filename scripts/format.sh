#!/usr/bin/env bash

# This script formats a document/file.
# I bind this to <leader>f in vim.

[[ -f "$1" ]] || exit 1
file="$(realpath -- "$1")"
ext="${file##*.}"
ext="${ext,,}"
dir=${file%/*}
base="${file%.*}"

format() {
	case "$ext" in
		c) clang-format -i --style "{BasedOnStyle: llvm, IndentWidth: 4}" "$file" ;;
		java) clang-format -i "$file" ;;
		lua)
			stylua \
				--collapse-simple-statement=Always \
				--column-width=80 \
				--indent-type=Spaces \
				--indent-width=2 \
				--space-after-function-names=Definitions \
				"$file"
			;;
		md) mdformat --wrap 80 "$file" ;;
		py) black "$file" ;;
		rs) rustfmt "$file" ;;
		tsx) npx prettier "$file" --write ;;
		typ) typstyle -i --wrap-text "$file" ;;
		xml|xslt|nfo)
			temp_file="$(mktemp)" &&
				xmllint --format -o "$temp_file" "$file" &&
				mv "$temp_file" "$file"
			;;
		*)
			notify-send -a nvim -r "$NID" "format.sh" "No formatting option for .$ext files specified."
			return 127
			;;
	esac
}

NID="$(notify-send -a nvim -p "format.sh" "Formatting $file...")"

cd "$dir" || exit 1

if format; then
	notify-send -a nvim -r "$NID" -t 2000 "format.sh" "Successfully formatted $file"
else
	status=$?
	(( status == 127 )) && exit 1
	notify-send -a nvim -r "$NID" -u critical "format.sh" "Formatting of $file failed (exit $status)."
fi
