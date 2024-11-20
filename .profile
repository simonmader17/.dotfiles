#    ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#    ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
#    ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
# ██╗██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
# ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝

# Reload pywal cache
command -v wal && wal -Rq

# Environmental variables
export EDITOR="vim"
export MANPAGER="vim +Man!"
export TERMINAL="kitty"
export BROWSER="firefox"
export PDF_READER="zathura"

# Gtk theme
export GTK_THEME="Vimix-dark-doder"

# When running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

# When running zsh
[ -n "$ZSH_VERSION" ] && [ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc" --no-greeting

# PATH stuff
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/scripts/aliases" ] && PATH="$HOME/scripts/aliases:$PATH"

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# ~/ clean up
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export DOT_SAGE="$XDG_CONFIG_HOME/sage"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export MAXIMA_USERDIR="$XDG_CONFIG_HOME/maxima"
export NBRC_PATH="$XDG_CONFIG_HOME/nbrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME/ts3client"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export XCURSOR_PATH="/usr/share/icons:$XDG_DATA_HOME/icons"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Device specific profile
[ -f "$HOME/.device-specific-profile" ] && source "$HOME/.device-specific-profile"
