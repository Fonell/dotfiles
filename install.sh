#!/usr/bin/env bash
cd "$(dirname "$0")"

ln -sf "$PWD/bashrc" ~/.bashrc
ln -sf "$PWD/bash_aliases" ~/.bash_aliases
ln -sf "$PWD/tmux.conf" ~/.tmux.conf
ln -sf "$PWD/gitconfig" ~/.gitconfig
ln -sf "$PWD/starship.toml" ~/.config/starship.toml
ln -sf "$PWD/lazygit.yml" ~/.config/lazygit/config.yml
ln -sf "$PWD/keymaps.lua" ~/.config/nvim/lua/config/keymaps.lua
ln -sf "$PWD/options.lua" ~/.config/nvim/lua/config/options.lua
ln -sf "$PWD/vim-tmux.lua" ~/.config/nvim/lua/plugins/vim-tmux.lua
