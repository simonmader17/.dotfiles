#!/usr/bin/env bash

# This script compiles a document/file.
# I bind this to <leader>c in vim.

# This script is inspired by Luke Smith's compiler script:
# https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/compiler

[[ -f "$1" ]] || exit 1
file="$(realpath -- "$1")"
ext="${file##*.}"
ext="${ext,,}"
dir=${file%/*}
base="${file%.*}"

compile() {
	case "$ext" in
		dot)
			dot -Tsvg "$file" -o "$base.svg"
			;;
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
		mom|ms) preconv "$file" | tbl | refer -PS -e | groff -Tpdf -m"$ext" > "$base.pdf" ;;
		puml)
			plantuml "$file"
			;;
		py)
			python3 "$file"
			;;
		rs)
			cargo run
			;;
		tex)
			# .tex files that should not be compiled using `pdflatex` should contain a
			# comment in the first line of the document, that contains the wanted TeX
			# engine (lualatex, xelatex, ...).
			engine="-pdf"
			case "$(head -n1 "$file")" in
				*[Ll]ua[Ll]a[Tt]e[Xx]*) engine="-lualatex" ;;
				*[Xx]e[Ll]a[Tt]e[Xx]*) engine="-xelatex" ;;
			esac
			latexmk \
				"$engine" \
				-file-line-error \
				-halt-on-error \
				-interaction=nonstopmode \
				"$file"
			;;
		typ)
			typst compile "$file"
			;;
		*)
			notify-send -a nvim -r "$NID" "compile.sh" "No compilation option for .$ext files specified."
			return 127
			;;
	esac
}

NID="$(notify-send -a nvim -p "compile.sh" "Compiling $file...")"

cd "$dir" || exit 1

if compile; then
	notify-send -a nvim -r "$NID" -t 2000 "compile.sh" "Finished compilation."
else
	status=$?
	(( status == 127 )) && exit 1
	notify-send -a nvim -r "$NID" -u critical "compile.sh" "Compilation of $file failed (exit $status)."
	exit "$status"
fi
