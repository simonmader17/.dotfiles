original_ps1="$PS1"
original_ps2="$PS2"
function update_prompt() {
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL)
			vi_mode_indicator="%F{blue}[N] %f"
    ;;
    $ZVM_MODE_INSERT)
			vi_mode_indicator="%F{green}[I] %f"
    ;;
    $ZVM_MODE_VISUAL)
			vi_mode_indicator="%F{yellow}[V] %f"
    ;;
    $ZVM_MODE_VISUAL_LINE)
			vi_mode_indicator="%F{yellow}[V] %f"
    ;;
    $ZVM_MODE_REPLACE)
			vi_mode_indicator="%F{red}[R] %f"
    ;;
	esac
	PS1="%B${vi_mode_indicator}%b${original_ps1}"
	PS2="%B${vi_mode_indicator}%b${original_ps2}"
}
zvm_after_init_commands+=(update_prompt)
zvm_after_select_vi_mode_commands+=(update_prompt)
