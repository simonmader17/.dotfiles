#    ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#    ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#    ██████╔╝███████║███████╗███████║██████╔╝██║
#    ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
# ██╗██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load pywal theme
if [[ "$TERM" != "xterm-kitty" ]] && [[ -r "$XDG_CACHE_HOME/wal/sequences" ]]; then
	(cat "$XDG_CACHE_HOME/wal/sequences" &)
	source "$XDG_CACHE_HOME/wal/colors-tty.sh"
fi

# Window title
__title() { printf '\e]0;%s@%s: %s\a' "$USER" "$HOSTNAME" "$1"; }
trap '__title "${BASH_COMMAND}"' DEBUG

# greeting
command -v greeting &>/dev/null && greeting

################################################################################
# BASIC SETTINGS
################################################################################

shopt -s extglob # enables bash's extended globbing: ?(), *(), +(), @(), !()
shopt -s globstar # ** recursion

# check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# History
HISTSIZE=1000000
HISTFILESIZE=1000000
[[ -d "$XDG_STATE_HOME/bash" ]] || mkdir -p "$XDG_STATE_HOME/bash"
HISTFILE="$XDG_STATE_HOME/bash/history"
shopt -s histappend
HISTCONTROL=ignoreboth # ignore dups and lines that start with a space

# prompt
PS1="\[\e[31m\][\[\e[92m\]\u\[\e[37m\] \[\e[94m\]\w\[\e[31m\]]\[\e[37m\]$\[\e[00m\] "

# Common shell configs
source "$XDG_CONFIG_HOME/shell/rc"
source "$XDG_CONFIG_HOME/shell/aliases"
