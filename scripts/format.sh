#!/usr/bin/env bash

# This script formats a document/file.
# I bind this to <leader>f in vim.

file="${1}"
ext="${file##*.}"
dir=${file%/*}
base="${file%.*}"

cd "$dir" || exit 1

case "$ext" in
	c) clang-format -i --style "{BasedOnStyle: llvm, IndentWidth: 4}" "$file" ;;
	java) clang-format -i "$file" ;;
	py) black "$file" ;;
	rs) rustfmt "$file" ;;
	tsx) npx prettier "$file" --write ;;
	typ) typstyle -i --wrap-text "$file" ;;
	xml|xslt) xmllint --format -o "$file" "$file" ;;
	*)
		notify-send -a nvim "format.sh" "No formatting option for .$ext files specified."
		exit 0
		;;
esac

if (( $? == 0 )); then
	notify-send -a nvim -t 1000 "format.sh" "Successfully formatted $file"
else
	notify-send -a nvim "format.sh" "Formatting of $file failed"
fi
