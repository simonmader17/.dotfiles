#!/bin/bash

# This script formats a document/file.
# I bind this to <leader>f in vim.

file="${1}"
ext="${file##*.}"
dir=${file%/*}
base="${file%.*}"

cd "$dir" || exit 1

case "$ext" in
	c)
		clang-format \
			-i \
			--style "{BasedOnStyle: llvm, IndentWidth: 4}" \
			"$file"
		;;
	java)
		clang-format \
			-i \
			"$file"
		;;
	rs)
		rustfmt "$file"
		;;
	xml)
		xmllint \
			--format \
			-o "$file" \
			"$file"
		;;
	*) notify-send -a nvim "format.sh" "No formatting option for .$ext files specified." ;;
esac
