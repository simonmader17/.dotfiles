#!/bin/bash

# This script compiles a document/file.
# I bind this to <leader>c in vim.

# This script is inspired by Luke Smith's compiler script:
# https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/compiler

file="${1}"
ext="${file##*.}"
dir=${file%/*}
base="${file%.*}"

NID="$(notify-send -p -a nvim "compile.sh" "Compiling $base...")"

cd "$dir" || exit 1

case "$ext" in
	mom|ms) preconv "$file" | tbl | refer -PS -e | groff -Tpdf -m"$ext" > "$base.pdf" ;;
	md)
		metadata="$(sed -n '/^---$/,/^---$/p' "$file")"
		echo "$metadata" | grep -qi "marp: true" && marp=true || marp=false
		echo "$metadata" | grep -qi "html: true" && html=true || html=false
		case "$marp$html" in
			truetrue) marp "$file" ;;
			truefalse) marp --pdf "$file" ;;
			falsetrue)
				pandoc \
					--verbose \
					-s \
					-o "$base.html" \
					"$file"
				;;
			falsefalse)
				pandoc \
					--verbose \
					--template eisvogel \
					-H ~/.local/share/pandoc/disable_float.tex \
					-o "$base.pdf" \
					"$file"
				;;
		esac
		;;
	puml)
		plantuml "$file"
		;;
	rs)
		cargo run
		;;
	tex)
		# .tex files that should not be compiled using `pdflatex` should contain a
		# comment in the first line of the document, that contains the wanted TeX
		# engine (lualatex, xelatex, ...).
		command="pdflatex"
		head -n1 "$file" | grep -qi "lualatex" && command="lualatex"
		head -n1 "$file" | grep -qi "xelatex" && command="xelatex"
		$command "$file"
		twice=false
		# For biber support:
		grep -qi "addbibresource" "$file" && biber "$base" && twice=true
		# Compile a second time in some cases:
		grep -qi "WithArrows" "$file" && twice=true
		grep -qi "tableofcontents" "$file" && twice=true
		[ "$twice" = true ] && NID="$(notify-send -p -r $NID -a nvim "compile.sh" "Second compilation of $base...")" && $command "$file"
		;;
	*) notify-send -r $NID -a nvim "compile.sh" "No compilation option for .$ext files specified." ;;
esac

notify-send -r $NID -t 1000 -a nvim "compile.sh" "Finished compilation."
