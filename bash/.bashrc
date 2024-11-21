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

if [ -f ~/.git-prompt.sh ]; then
  . ~/.git-prompt.sh
fi
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

export PATH="${PATH:+${PATH}:}/home/user/.local/bin"
export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0

eval "$(zoxide init bash)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(fzf --bash)"
