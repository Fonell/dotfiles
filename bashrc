shopt -s histappend
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%F %T "
HISTSIZE=-1
HISTFILESIZE=-1

. ~/.bash_aliases

export EDITOR=nvim
export VISUAL=nvim

eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
