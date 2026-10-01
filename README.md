# Dotfiles

## Tools

- git, tmux, neovim, ripgrep, fd, fzf (0.48+), zoxide, starship, eza, lazygit, delta
- build-essential, unzip (for LazyVim)
- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads) in your terminal

## Install

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim && rm -rf ~/.config/nvim/.git
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/Fonell/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

In tmux, press `prefix + I` to install plugins.
