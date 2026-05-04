#!/usr/bin/env bash
set -euo pipefail

# Verify Ubuntu 24
if [[ "$(lsb_release -rs 2>/dev/null)" != 24.* ]]; then
  echo "warning: Ubuntu 24 recommended (found: $(lsb_release -ds 2>/dev/null))" >&2
  read -rp "  Continue anyway? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
fi

is_cmd() { command -v "$1" &>/dev/null; }

ARCH=$(uname -m)                                                    # x86_64 or aarch64
ARCH_GO=${ARCH/aarch64/arm64}                                       # x86_64 or arm64
ARCH_DEB=${ARCH/x86_64/amd64}; ARCH_DEB=${ARCH_DEB/aarch64/arm64}  # amd64 or arm64

gh_bin() {
  is_cmd "$1" && return
  local url; url=$(curl -fsSL "https://api.github.com/repos/$2/releases/latest" \
    | grep -Po '"browser_download_url":\s*"\K[^"]+' | grep -E "$3" | head -1)
  local tmp; tmp=$(mktemp -d)
  curl -fsSL "$url" | tar -xz -C "$tmp"
  sudo find "$tmp" -maxdepth 4 -name "$1" -type f -exec install -m755 {} /usr/local/bin/ \;
  rm -rf "$tmp"
}

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
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt-get update -y
sudo apt install -y git-all curl stow tmux ripgrep wslu \
  ninja-build gettext cmake unzip build-essential fastfetch

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

step "Installing CLI tools"
is_cmd starship    || curl -sS https://starship.rs/install.sh | sh -s -- -y
gh_bin eza        eza-community/eza         "eza_${ARCH}-unknown-linux-musl\.tar\.gz"
gh_bin fd         sharkdp/fd               "fd-v[0-9.]+-${ARCH}-unknown-linux-musl\.tar\.gz"
gh_bin zoxide     ajeetdsouza/zoxide        "zoxide-[0-9.]+-${ARCH}-unknown-linux-musl\.tar\.gz"
gh_bin fzf        junegunn/fzf             "fzf-[0-9.]+-linux_${ARCH_DEB}\.tar\.gz"
gh_bin lazygit    jesseduffield/lazygit    "lazygit_[0-9.]+_[Ll]inux_${ARCH_GO}\.tar\.gz"
gh_bin lazydocker jesseduffield/lazydocker "lazydocker_[0-9.]+_Linux_${ARCH_GO}\.tar\.gz"
gh_bin delta      dandavison/delta         "delta-[0-9.]+-${ARCH}-unknown-linux-musl\.tar\.gz"
gh_bin gh         cli/cli                  "gh_[0-9.]+_linux_${ARCH_DEB}\.tar\.gz"

step "Installing Docker"
[[ -f /usr/bin/docker ]] || {
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"
}

step "GitHub auth"
gh auth status &>/dev/null || gh auth login

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
fastfetch
