#!/usr/bin/fish

function _change_theme_completions
	set -l current_path (pwd)
	cd ~/scripts/pywal/themes/
	/bin/ls *.json | sed -e 's/\.json$//'
	cd $current_path
end

complete -f -c change-theme -a '(_change_theme_completions)'
