# enable prompt substitutions
setopt prompt_subst
# load vcs_info
autoload -Uz vcs_info
precmd_functions+=(vcs_info)

# enable vcs_info only for git to improve performance
zstyle ':vcs_info:*' enable git
# causes %c and %u to show, potentially computationally expensive
zstyle ':vcs_info:*' check-for-changes true

# hooks
+vi-git-ahead() {
	commits="$(git rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)"
	(( $? != 0 )) && return
	IFS=$'\t' read -r behind ahead <<< "$commits"
	(( ahead > 0 )) && hook_com[misc]="${hook_com[misc]} ↑$ahead"
	(( behind > 0 )) && hook_com[misc]="${hook_com[misc]} ↓$behind"
	return 0
}
+vi-git-branch-color() {
	if [[ "${hook_com[branch]}" =~ ^(main|master)$ ]]; then
		hook_com[branch]="%F{red}${hook_com[branch]}%f"
	else
		hook_com[branch]="%F{blue}${hook_com[branch]}%f"
	fi
	return 0
}
zstyle ':vcs_info:*+set-message:*' hooks git-ahead git-branch-color

# vcs_info replacements:
# - %b ... current branch
# - %u ... unstagedstr
# - %c ... stagedstr
# - %m ... "misc" information
zstyle ':vcs_info:*' formats       \
	' %b%F{yellow}%u%c%m%f'
zstyle ':vcs_info:*' actionformats \
	' %b (%F{blue}%a%f)%F{yellow}%u%c%m%f'
zstyle ':vcs_info:*' unstagedstr   \
	' ✗'
zstyle ':vcs_info:*' stagedstr     \
	' '

### BUILD PROMPT ###############################################################

# exit code of last process
PS1='%(?..%B%F{red}[%?]%b%f )'
# begin of prompt
PS1+='%(?.%F{244}[%f.%B%F{red}[%b%f)'
# username
PS1+='%B%F{blue}%n%b%f'
# at sign
PS1+='%(?.%F{244}@%f.%B%F{red}@%b%f)'
# hostname
PS1+='%B%F{magenta}%M%b%f '
# pwd
PS1+='%B%F{cyan}%1~%b%f'
# git info
PS1+='${vcs_info_msg_0_}'
# end of prompt
PS1+='%(?.%F{244}]%f%B%F{yellow}$%b%f.%B%F{red}]$%b%f) '

PS2="%F{yellow}>%f "
