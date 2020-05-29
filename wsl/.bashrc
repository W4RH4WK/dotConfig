[[ $- != *i* ]] && return

# ------------------------------------------------------------ History
HISTCONTROL=ignoreboth
HISTSIZE=10000
shopt -s histappend

# ------------------------------------------------------------ Basics
shopt -s checkwinsize
shopt -s globstar
shopt -u dotglob

# ------------------------------------------------------------ Editor
alias vim="nvim"
alias view="nvim -R"
export EDITOR="/usr/bin/nvim"
export MANPAGER="/usr/bin/nvim -c 'set filetype=man' -"

# ------------------------------------------------------------ Prompt
PROMPT_DIRTRIM=2
PROMPT_COMMAND='history -a; echo -en "\033]0;$PWD\a"'

__ret_ps1() {
	if [[ $1 != 0 ]]; then
		echo -n " $1"
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

	PS1="$BBlue\w$BYellow\$(__git_ps1)$BRed\$(__ret_ps1 \$?)$BGreen > $NC"
	PS2="$BGreen> $NC"
}

__set_ps1

# ------------------------------------------------------------ Alias
tssh() {
	ssh -t "$@" tmux new-session -A -s 0
}

autotssh() {
	autossh -t "$@" tmux new-session -A -s 0
}

tosh() {
	mosh -- "$@" tmux new-session -A -s 0
}

alias ag="ag --smart-case --follow"
alias gdb="gdb -q"
alias l="ls --classify --color=force --group-directories-first --human-readable -l"
alias ll="l --all"
alias open="cmd.exe /C start"
alias tree="tree -F --dirsfirst"
alias ts="tig status"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../.."
alias ......="cd ../../../.."

# ------------------------------------------------------------ Completion
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
	source /usr/share/bash-completion/bash_completion
fi

# ------------------------------------------------------------ Ranger
if [[ -f /usr/share/doc/ranger/examples/bash_automatic_cd.sh ]]; then
	source /usr/share/doc/ranger/examples/bash_automatic_cd.sh 
fi

# ------------------------------------------------------------ WSL Stuff
if [[ -f /etc/wsl.conf ]]; then
	# Permissions
	umask 0022

	export DISPLAY=localhost:0

	# SSH Agent
	if [[ -z "$(pgrep ssh-agent)" ]]; then
		rm -rf /tmp/ssh-*
		eval $(ssh-agent -s) > /dev/null
	else
		export SSH_AGENT_PID=$(pgrep ssh-agent)
		export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
	fi
fi

# ------------------------------------------------------------ PATH
# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Ruby
export PATH="$(ruby -rrubygems -e 'puts Gem.user_dir')/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Local
export PATH="$HOME/.local/bin:$PATH"
