#!/usr/bin/env bash

_change_theme_completions() {
	current_path=$(pwd)
	cd ~/scripts/pywal/themes/
	COMPREPLY=($(compgen -W "$(/bin/ls *.json | sed -e 's/\.json$//')" -- "${COMP_WORDS[1]}"))
	cd $current_path
}

complete -F _change_theme_completions change-theme
