#    ███████╗███████╗██╗  ██╗██████╗  ██████╗
#    ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#      ███╔╝ ███████╗███████║██████╔╝██║
#     ███╔╝  ╚════██║██╔══██║██╔══██╗██║
# ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# Load pywal theme
if [[ "$TERM" != "xterm-kitty" ]] && [[ -r "$XDG_CACHE_HOME/wal/sequences" ]]; then
	(cat "$XDG_CACHE_HOME/wal/sequences" &)
	source "$XDG_CACHE_HOME/wal/colors-tty.sh"
fi

# Window title
precmd () { print -Pn "\e]0;%n@%M: %~\a" }
preexec () { print -Pn "\e]0;%n@%M: ${1:gs/%/%%}\a" }

# greeting
command -v greeting &>/dev/null && greeting

################################################################################
# BASIC SETTINGS
################################################################################

setopt EXTENDED_GLOB # match ~ # ^
setopt INTERACTIVE_COMMENTS # allow comments in shell

# History
HISTSIZE=1000000
SAVEHIST=1000000
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE # ignore lines that start with a space
setopt SHARE_HISTORY # history lines are added as soon as they are entered

################################################################################
# COMPLETIONS
################################################################################

# zsh-completions
fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)

# zsh-autocomplete
source "$ZDOTDIR/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# Auto-include recent directories
zstyle -e ':completion:*:directories' fake '
	[[ -z $PREFIX$SUFFIX || -d $PREFIX$SUFFIX ]] ||
		chpwd_recent_filehandler
'
zstyle ':completion:*:directories' sort no

# colorize cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} 'ma=38;5;0;48;5;14'

# zsh-autosuggestions
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

################################################################################

# zsh-vi-mode
source "$ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.zsh"
ZVM_CURSOR_STYLE_ENABLED=false

# prompt
source "$ZDOTDIR/themes/boxy-zsh-theme/boxy.zsh-theme"

# must be loaded after prompt
source "$ZDOTDIR/plugins/zsh-vi-mode-indicator/zsh-vi-mode-indicator.plugin.zsh"

# Common shell configs
source "$XDG_CONFIG_HOME/shell/rc"
source "$XDG_CONFIG_HOME/shell/aliases"

# zsh-syntax-highlighting (should be at the end of the config file)
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# zsh-history-substring-search (must be after zsh-syntax-highlighting)
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

init_other_plugins() {
	zmodload zsh/complist
	zmodload zsh/terminfo

	# Cycle through completion menu using Tab and Shift-Tab
	bindkey '\t' menu-select
	bindkey "${terminfo[kcbt]}" menu-select
	bindkey -M menuselect '\t' menu-complete
	bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete

	# History substring search
	local mode
	for mode in viins vicmd; do
		bindkey -M "$mode" '^[[A' history-substring-search-up # arrow up
		bindkey -M "$mode" '^[OA' history-substring-search-up # arrow up
		bindkey -M "$mode" '^P' history-substring-search-up # Control-P
		bindkey -M "$mode" '^[[B' history-substring-search-down # arrow down
		bindkey -M "$mode" '^[OB' history-substring-search-down # arrow down
		bindkey -M "$mode" '^N' history-substring-search-down # arrow down
	done
}
zvm_after_init_commands+=(init_other_plugins)
