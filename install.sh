#!/usr/bin/env bash
set -euo pipefail

step() {
  echo
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  ▶ $1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo
}

step "Updating system"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

step "Installing apt packages"
sudo apt install -y git-all curl stow tmux ripgrep wslu \
  ninja-build gettext cmake unzip build-essential

step "Installing neovim"
[[ -d ~/neovim ]] || git clone https://github.com/neovim/neovim.git ~/neovim
[[ -f /usr/local/bin/nvim ]] || (cd ~/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install)

step "Installing LazyVim"
[[ -f ~/.config/nvim/init.lua ]] || {
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
}

step "Installing tmux TPM"
[[ -d ~/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

step "Installing Homebrew"
[[ -f /home/linuxbrew/.linuxbrew/bin/brew ]] || \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

step "Installing brew packages"
brew install eza lazygit jesseduffield/lazydocker/lazydocker starship fd fzf zoxide gh

step "Installing Docker"
[[ -f /usr/bin/docker ]] || {
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"
}

step "GitHub auth"
gh auth login

step "Applying dotfiles"
[[ -d ~/dotfiles ]] || {
  git clone git@github.com:Fonell/dotfiles.git ~/dotfiles ||
    git clone https://github.com/Fonell/dotfiles.git ~/dotfiles
}
(
  cd ~/dotfiles
  stow --adopt */
  git restore .
)

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Done! Restart your shell or run: source ~/.bashrc"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
