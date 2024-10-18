#    ███████╗███████╗██╗  ██╗██████╗  ██████╗
#    ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#      ███╔╝ ███████╗███████║██████╔╝██║     
#     ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
# ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

################################################################################
# Greeting
################################################################################

if [ -n "$1" ] && [ "$1" != "--no-greeting" ]; then
	echo "Usage: source $0 [ --no-greeting ]"
	return 1
fi

greeting() {
	if type colorscript &>/dev/null && type krabby &>/dev/null; then
		if [ $(($RANDOM % 2)) = 0 ]; then
			colorscript -r
		else
			[ $(($RANDOM % 4096)) -eq 0 ] && krabby random --shiny || krabby random
		fi
	else
		type cowsay &>/dev/null && cowsay "Hello $USER" || echo "Hello $USER"
	fi
}
if [ "$1" != "--no-greeting" ]; then
	[ -f /usr/local/bin/greeting ] && /usr/local/bin/greeting || greeting
fi

################################################################################
# Basic settings
################################################################################

stty -ixon # Disable ctrl-s and ctrl-q

# Change prompt
source ~/.config/zsh/themes/sashimi-zsh-theme/sashimi.zsh-theme

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt hist_ignore_all_dups

# Aliases
source ~/.config/aliases/aliases

# Basic auto/tab completions
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit
_comp_options+=(globdots) # Include hidden files
zstyle ':completion:*' menu select
bindkey '^[[Z' reverse-menu-complete # Enable Shift+Tab in menu selection

# Load pywal theme
if [ "$TERM" != "xterm-kitty" ]; then
	/usr/bin/cat ~/.cache/wal/sequences
fi

# NordVPN automatically update polybar hook
nordvpn() {
	command nordvpn $@
	type polybar-msg &>/dev/null && polybar-msg hook nordvpn 1 >/dev/null
}

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# react-native
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH"

# CHROME_PATH for marp
export CHROME_PATH="$(which brave-browser)"

# Go
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Load Angular CLI autocompletion.
type ng &>/dev/null && source <(ng completion script)

# change-theme completions
source ~/scripts/pywal/change-theme/change-theme-completions-bash.sh

# flutter sdk
export PATH="$HOME/.local/share/flutter/sdk/flutter/bin:$PATH"

# fnm - Fast and simple Node.js version manager
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
eval "$(fnm completions --shell zsh)"

################################################################################
# Plugins
################################################################################
	
# zsh-autosuggestions
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-autocomplete
source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# zstyle ':autocomplete:history-search-backward:*' list-lines 16

# zsh-vi-mode
source ~/.config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
function zvm_after_select_vi_mode() {
	# The vi mode indicator code below depends on my Sashimi zsh theme (loaded in line 9):
	# https://github.com/simonmader17/sashimi-zsh-theme
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL)
			vi_mode_indicator="%B%{$fg[blue]%}[N]%{$reset_color%}"
			PROMPT='$vi_mode_indicator $(sashimi)'
			;;
		$ZVM_MODE_INSERT)
			vi_mode_indicator="%B%{$fg[green]%}[I]%{$reset_color%}"
			PROMPT='$vi_mode_indicator $(sashimi)'
			;;
		$ZVM_MODE_VISUAL)
			vi_mode_indicator="%B%{$fg[yellow]%}[V]%{$reset_color%}"
			PROMPT='$vi_mode_indicator $(sashimi)'
			;;
		$ZVM_MODE_VISUAL_LINE)
			vi_mode_indicator="%B%{$fg[yellow]%}[V]%{$reset_color%}"
			PROMPT='$vi_mode_indicator $(sashimi)'
			;;
		$ZVM_MODE_REPLACE)
			vi_mode_indicator="%B%{$fg[red]%}[R]%{$reset_color%}"
			PROMPT='$vi_mode_indicator $(sashimi)'
			;;
	esac
}
zvm_after_init_commands+=(zvm_after_select_vi_mode)
ZVM_CURSOR_STYLE_ENABLED=false
function init_other_plugins() {
	# Cycle through completion menu using Tab and Shift-Tab
	bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
	bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
}
zvm_after_init_commands+=(init_other_plugins)

# zsh-colored-man-pages
source ~/.config/zsh/plugins/zsh-colored-man-pages/colored-man-pages.plugin.zsh

# zsh-syntax-highlighting (should be at the end of the config file)
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-history-substring-search
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down
