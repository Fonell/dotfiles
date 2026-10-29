# Dotfiles

## Tools

- git, tmux, ripgrep, fd, fzf (0.48+), zoxide, starship, eza, lazygit, delta
- neovim (0.12+)
- tree-sitter CLI and a C compiler (gcc), for treesitter parsers
- node and npm, for Mason language servers and prettier
- curl, unzip, tar, gzip, for Mason downloads
- wl-clipboard (Wayland) or xclip (X11), for the system clipboard
- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads) in your terminal

## Install

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/Fonell/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

In tmux, press `prefix + I` to install plugins.
