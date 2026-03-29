#!/usr/bin/env bash

set -euo pipefail

LOGFILE="$HOME/dev_env_install.log"
exec > >(tee -a "$LOGFILE") 2>&1

draw_header() {
  clear
  local width=$(tput cols)
  local title="$1"
  printf "\n\n"
  printf "%*s\n" $(((${#title} + width) / 2)) "$title"
  printf "%*s\n\n" $(((${#title} + width) / 2)) "$(printf '%.0s=' $(seq 1 ${#title}))"
}

pause() {
  echo ""
  echo -n "➡️  Press Enter to continue..."
  read -r
}

error_exit() {
  echo "❌ Error: $1" >&2
  exit 1
}

is_pkg_installed() {
  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

is_cmd_installed() {
  command -v "$1" >/dev/null 2>&1
}

run_step() {
  local step_name="$1"
  shift
  draw_header "🚀 $step_name"
  "$@"
  echo ""
  pause
}

update_system() {
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get dist-upgrade -y
}

check_and_update_git() {
  local required_version="2.32.0"
  local current_version
  if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing latest Git..."
  else
    current_version=$(git --version | awk '{print $3}')
    printf "Current Git version: %s\n" "$current_version"
    if [ "$(printf '%s\n%s\n' "$required_version" "$current_version" | sort -V | head -n1)" = "$required_version" ]; then
      echo "Git version is sufficient."
      return
    else
      echo "Git version is less than required $required_version. Upgrading Git..."
    fi
  fi

  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt-get update -y
  sudo apt-get install -y git
  echo "Git upgraded to version: $(git --version | awk '{print $3}')"
}

install_build_deps() {
  local pkgs=(ninja-build gettext cmake unzip curl build-essential)
  for pkg in "${pkgs[@]}"; do
    if is_pkg_installed "$pkg"; then
      echo "✔️ $pkg is already installed."
    else
      sudo apt-get install -y "$pkg"
    fi
  done
}

install_neovim() {
  if is_cmd_installed nvim; then
    echo "✔️ Neovim already installed."
  else
    if [ ! -d "$HOME/neovim" ]; then
      git clone https://github.com/neovim/neovim.git "$HOME/neovim"
    fi
    cd "$HOME/neovim"
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd ~
  fi
}

install_lazyvim() {
  if [ -d "$HOME/.config/nvim" ] && [ -f "$HOME/.config/nvim/init.lua" ]; then
    echo "✔️ LazyVim already set up."
  else
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
  fi
}


install_zoxide() {
  if is_cmd_installed zoxide; then
    echo "✔️ zoxide already installed."
  else
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  fi

  echo "⚠️ Note: Please configure your shell initialization (e.g. in dotfiles) to enable zoxide integration."
}

install_ripgrep_fd() {
  if is_cmd_installed rg; then
    echo "✔️ ripgrep already installed."
  else
    sudo apt-get install -y ripgrep
  fi

  if is_cmd_installed fd; then
    echo "✔️ fd already installed."
  else
    # Install latest fd from GitHub releases
    FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" |
      grep -Po '"tag_name": "v\K[0-9.]+')

    curl -Lo /tmp/fd.deb \
      "https://github.com/sharkdp/fd/releases/latest/download/fd_${FD_VERSION}_amd64.deb"

    sudo apt-get install -y /tmp/fd.deb
    rm -f /tmp/fd.deb

    # Ensure `fd` is on PATH (GitHub .deb already uses `fd` as the binary name).[web:7]
    if ! command -v fd >/dev/null 2>&1; then
      echo "fd installed but not on PATH"
    fi
  fi
}

install_brew_fzf() {
  if is_cmd_installed brew; then
    echo "✔️ Homebrew already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  if is_cmd_installed fzf; then
    echo "✔️ fzf already installed."
  else
    brew install fzf
  fi
}

install_lazygit() {
  if is_cmd_installed lazygit; then
    echo "✔️ Lazygit already installed."
  else
    local version
    version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version#v}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
  fi
}

install_wslu() {
  if is_cmd_installed wslview; then
    echo "✔️ wslview already installed."
  else
    sudo apt-get install -y wslu
  fi
}

install_stow_dotfiles() {
  if is_cmd_installed stow; then
    echo "✔️ stow installed."
  else
    sudo apt-get install -y stow
  fi

  local dotfiles_dir="$HOME/dotfiles"
  if [ -d "$dotfiles_dir" ]; then
    echo "✔️ Dotfiles repo already cloned."
  else
    echo "Cloning dotfiles repo..."
    git clone git@github.com:Fonell/dotfiles.git "$dotfiles_dir" || git clone https://github.com/Fonell/dotfiles.git "$dotfiles_dir"
  fi

  cd "$dotfiles_dir"
  stow --adopt */
  git restore .
  cd ~
}

main() {
  run_step "Update and upgrade system packages" update_system
  run_step "Check and upgrade git if needed" check_and_update_git
  run_step "Install build dependencies" install_build_deps
  run_step "Install Neovim from source" install_neovim
  run_step "Install LazyVim configuration" install_lazyvim
  run_step "Install zoxide" install_zoxide
  run_step "Install ripgrep and fd" install_ripgrep_fd
  run_step "Install Homebrew and fzf" install_brew_fzf
  run_step "Install Lazygit" install_lazygit
  run_step "Install wslu (wslview)" install_wslu
  run_step "Install stow and apply dotfiles" install_stow_dotfiles

  draw_header "✅ Development environment setup completed!"
  echo ""
  echo "Log saved at: $LOGFILE"
  echo ""
  echo "⚠️ Reminder for Windows users:"
  echo "  - Set WezTerm font to JetBrainsMono Nerd Font."
  echo "  - Clipboard uses OSC52 — no extra tools needed."
  echo ""
  echo "Please restart your shell or run: source ~/.bashrc (or appropriate shell config)"
  echo ""
}

main
