#!/usr/bin/env bash
cd "$(dirname "$0")"

ln -sf "$PWD/bashrc" ~/.bashrc
ln -sf "$PWD/bash_aliases" ~/.bash_aliases
ln -sf "$PWD/tmux.conf" ~/.tmux.conf
ln -sf "$PWD/gitconfig" ~/.gitconfig
ln -sf "$PWD/starship.toml" ~/.config/starship.toml
ln -sf "$PWD/lazygit.yml" ~/.config/lazygit/config.yml
[ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
ln -sfn "$PWD/nvim" ~/.config/nvim
