# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%F %T "
HISTSIZE='yes'
HISTFILESIZE='please'
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export PATH="${PATH:+${PATH}:}/home/user/.local/bin"
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export AWS_PROFILE=dev
export EDITOR=nvim
export VISUAL=nvim

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
