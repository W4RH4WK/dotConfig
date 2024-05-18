[[ $- != *i* ]] && return

source_if_exists() {
	if [[ -f "$1" ]]; then
		source "$1"
	fi
}

# ------------------------------------------------------------ Options
shopt -s checkwinsize
shopt -s globstar
shopt -u dotglob

HISTCONTROL=ignoreboth
HISTSIZE=10000
shopt -s histappend

# ------------------------------------------------------------ Prompt
PROMPT_DIRTRIM=2
PROMPT_COMMAND='echo -en "\033]0;$PWD\a"'

__ret_ps1() {
	if [[ $1 != 0 ]]; then
		echo -n " $1"
	fi
}

__jobs_ps1() {
	if [[ $1 -gt 0 ]]; then
		echo -n '•'
	fi
}

__set_ps1() {
	local NC='\[\e[0m\]'
	local Black='\[\e[0;30m\]'
	local Red='\[\e[0;31m\]'
	local Green='\[\e[0;32m\]'
	local Yellow='\[\e[0;33m\]'
	local Blue='\[\e[0;34m\]'
	local Purple='\[\e[0;35m\]'
	local Cyan='\[\e[0;36m\]'
	local White='\[\e[0;37m\]'
	local BBlack='\[\e[1;30m\]'
	local BRed='\[\e[1;31m\]'
	local BGreen='\[\e[1;32m\]'
	local BYellow='\[\e[1;33m\]'
	local BBlue='\[\e[1;34m\]'
	local BPurple='\[\e[1;35m\]'
	local BCyan='\[\e[1;36m\]'
	local BWhite='\[\e[1;37m\]'

	PS1="$BBlue\w$BYellow\$(__git_ps1)$BRed\$(__ret_ps1 \$?)$BGreen \$(__jobs_ps1 \j)> $NC"
	PS2="$BGreen> $NC"
}

__set_ps1

# ------------------------------------------------------------ Man Pager
export MANPAGER="less -s -M +Gg"
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# ------------------------------------------------------------ Editor
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"
export EDITOR="nvim"

# ------------------------------------------------------------ Aliases
open() {
	if [[ -f /etc/wsl.conf ]]; then
		cmd.exe /C start "$(wslpath -w "$1")"
	else
		xdg-open "$1"
	fi
}

tssh() {
	ssh -t "$@" tmux new-session -A -s 0
}

tosh() {
	mosh -- "$@" tmux new-session -A -s 0
}

alias l="ls -l --classify --color=force --group-directories-first --human-readable"
alias ll="l --all"
alias tree="tree -F --dirsfirst"
alias rgg="rg --hidden --no-ignore"
alias fdd="fd --hidden --no-ignore"
alias lg="lazygit"
alias ts="tig status"
alias gdb="gdb --quiet"

# ------------------------------------------------------------ Completion
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

source_if_exists /usr/share/bash-completion/bash_completion
source_if_exists /usr/share/doc/fzf/examples/key-bindings.bash

export FZF_DEFAULT_COMMAND="fd ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type directory ."

if [[ -f "$HOME/.cargo/bin/zoxide" ]]; then
	eval "$($HOME/.cargo/bin/zoxide init bash)"
fi

# ------------------------------------------------------------ lf
lfcd () {
	local tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [[ -f "$tmp" ]]; then
		local dir="$(cat "$tmp")"
		rm -f "$tmp"
		if [[ -d "$dir" ]]; then
			if [[ "$dir" != "$(pwd)" ]]; then
				cd "$dir"
			fi
		fi
	fi
}
bind '"\eo":"lfcd\C-m"'

mccd() {
	local tmp="$(mktemp --dry-run)"
	mc --printwd="$tmp"
	if [[ -f "$tmp" ]]; then
		local dir="$(cat "$tmp")"
		rm -f "$tmp"
		if [[ -d "$dir" ]]; then
			if [[ "$dir" != "$(pwd)" ]]; then
				cd "$dir"
			fi
		fi
	fi
}
# bind '"\eo":"mccd\C-m"'

# ------------------------------------------------------------ SSH Agent
if [[ -z "$(pgrep ssh-agent 2>/dev/null)" ]]; then
	rm -rf /tmp/ssh-*
	eval $(ssh-agent -s) > /dev/null
else
	export SSH_AGENT_PID=$(pgrep ssh-agent)
	export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
fi

# ------------------------------------------------------------ WSL Specific
if [[ -f /etc/wsl.conf ]]; then
	export DISPLAY=localhost:0
fi

# ------------------------------------------------------------ PATH
# Go
export PATH="$HOME/go/bin:$PATH"

# Ruby
if [[ -f /usr/bin/ruby ]]; then
	export GEM_HOME="$(ruby -rrubygems -e 'puts Gem.user_dir')"
	export PATH="$(ruby -rrubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Rust
source_if_exists $HOME/.cargo/env
export PATH="$HOME/.cargo/bin:/usr/lib/cargo/bin:$PATH"

# Local
export PATH="$HOME/.local/bin:$PATH"
