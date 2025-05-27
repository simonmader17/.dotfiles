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
			[ $(($RANDOM % 4096)) -eq 0 ] && krabby random --info --shiny || krabby random --info
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

setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines

# Window title
precmd () { print -Pn "\e]0;%n@%M: %~\a" } 
preexec () { print -Pn "\e]0;%n@%M: $1\a" }

# History
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.cache/zsh/history
setopt hist_ignore_all_dups append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds are executed; history shared across sessions

# Aliases
source ~/.config/aliases/aliases

# Basic auto/tab completions
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit
_comp_options+=(globdots) # Include hidden files
zstyle ':completion:*' menu select # tab opens cmp menu
bindkey '^[[Z' reverse-menu-complete # Enable Shift+Tab in menu selection
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} 'ma=38;5;0;48;5;14' # colorize cmp menu

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

# Load Angular CLI autocompletion.
type ng &>/dev/null && source <(ng completion script)

# change-theme completions
source ~/scripts/pywal/change-theme/change-theme-completions-bash.sh

# flutter sdk
export PATH="$HOME/.local/share/flutter/sdk/flutter/bin:$PATH"

# fnm - Fast and simple Node.js version manager
type fnm &>/dev/null && eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
type fnm &>/dev/null && eval "$(fnm completions --shell zsh)"

# gpg-agent
export GPG_TTY="$(tty)"

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
ZVM_CURSOR_STYLE_ENABLED=false
function init_other_plugins() {
	# Cycle through completion menu using Tab and Shift-Tab
	bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
	bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
}
zvm_after_init_commands+=(init_other_plugins)

# zsh-syntax-highlighting (should be at the end of the config file)
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-history-substring-search
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# prompt
NEWLINE=$'\n'
# PS1="${NEWLINE}%B%F{cyan}%n%b%f @ %B%F{yellow}%M%b%f in %B%F{green}%~%b%f ${NEWLINE}%B%F{blue}$%b%f "
# PS2="%F{blue}>%f "
# PS1='%K{black} black %k%K{red} red %k%K{green} green %k%K{yellow} yellow %k%K{blue} blue %k%K{magenta} magenta %k%K{cyan} cyan %k%K{white} white %k%# '
PS1="%F{244}[%f%B%F{blue}%n%b%f%F{244}@%f%B%F{magenta}%M%b%f %B%F{cyan}%1~%b%f%F{244}]%f%B%F{yellow}$%b%f "
PS2="%F{yellow}>%f "

# Change prompt
# source ~/.config/zsh/themes/sashimi-zsh-theme/sashimi.zsh-theme

source ~/.config/zsh/plugins/zsh-vi-mode-indicator/zsh-vi-mode-indicator.plugin.zsh
