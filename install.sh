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

SKIP_PAUSES="false"

pause() {
  if [ "$SKIP_PAUSES" = "true" ]; then
    return
  fi
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
    (
      cd "$HOME/neovim"
      make CMAKE_BUILD_TYPE=RelWithDebInfo
      sudo make install
    )
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

install_tmux_tpm() {
  if is_cmd_installed tmux; then
    echo "✔️ tmux already installed."
  else
    brew install tmux
  fi
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    echo "✔️ TPM already installed."
  fi
}

install_zoxide() {
  if is_cmd_installed zoxide; then
    echo "✔️ zoxide already installed."
  else
    brew install zoxide
  fi

  echo "⚠️ Note: Please configure your shell initialization (e.g. in dotfiles) to enable zoxide integration."
}

install_ripgrep_fd() {
  if is_cmd_installed rg; then
    echo "✔️ ripgrep already installed."
  else
    brew install ripgrep
  fi

  if is_cmd_installed fd; then
    echo "✔️ fd already installed."
  else
    brew install fd
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

install_starship() {
  if is_cmd_installed starship; then
    echo "✔️ starship already installed."
  else
    brew install starship
  fi
}

install_eza() {
  if is_cmd_installed eza; then
    echo "✔️ eza already installed."
  else
    brew install eza
  fi
}

install_lazygit() {
  if is_cmd_installed lazygit; then
    echo "✔️ Lazygit already installed."
  else
    brew install lazygit
  fi
  if is_cmd_installed delta; then
    echo "✔️ delta already installed."
  else
    brew install git-delta
  fi
}

install_wslu() {
  if is_cmd_installed wslview; then
    echo "✔️ wslview already installed."
  else
    sudo apt-get install -y wslu
  fi
}

install_docker() {
  if is_cmd_installed docker; then
    echo "✔️ Docker already installed."
    return
  fi

  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"

  if grep -qs "systemd=true" /etc/wsl.conf; then
    sudo systemctl enable --now docker
    echo "✔️ Docker service enabled via systemd."
  else
    if ! grep -q "dockerd" "$HOME/.bashrc"; then
      cat >>"$HOME/.bashrc" <<'EOF'

# Auto-start Docker daemon in WSL (no systemd)
if [ -z "$(pgrep dockerd)" ]; then
    sudo dockerd > /dev/null 2>&1 &
fi
EOF
    fi
    echo "⚠️  systemd not enabled. Added dockerd auto-start to ~/.bashrc."
    echo "    For a cleaner setup, add to /etc/wsl.conf and run 'wsl --shutdown':"
    echo "      [boot]"
    echo "      systemd=true"
  fi

  echo "✔️ Docker installed. Run 'newgrp docker' or re-login for group changes to take effect."
}

install_lazydocker() {
  if is_cmd_installed lazydocker; then
    echo "✔️ Lazydocker already installed."
  else
    brew install jesseduffield/lazydocker/lazydocker
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
  # Remove existing files that would conflict, then stow cleanly
  for dir in */; do
    stow -n "$dir" 2>&1 | grep -oP '(?<=existing target is not owned by stow: ).*' | while read -r conflict; do
      rm -f "$HOME/$conflict"
    done || true
  done
  stow */
  cd ~
}

declare -A STEPS=(
  [system]="Update and upgrade system packages"
  [git]="Check and upgrade git if needed"
  [build_deps]="Install build dependencies"
  [neovim]="Install Neovim from source"
  [lazyvim]="Install LazyVim configuration"
  [tmux]="Install tmux and TPM"
  [zoxide]="Install zoxide"
  [ripgrep_fd]="Install ripgrep and fd"
  [eza]="Install eza"
  [brew_fzf]="Install Homebrew and fzf"
  [starship]="Install starship prompt"
  [lazygit]="Install Lazygit"
  [wslu]="Install wslu (wslview)"
  [docker]="Install Docker Engine (no Docker Desktop)"
  [lazydocker]="Install Lazydocker"
  [stow]="Install stow and apply dotfiles"
)

STEP_ORDER=(system git build_deps brew_fzf neovim lazyvim tmux zoxide ripgrep_fd eza starship lazygit wslu docker lazydocker stow)

declare -A STEP_FUNCS=(
  [system]=update_system
  [git]=check_and_update_git
  [build_deps]=install_build_deps
  [neovim]=install_neovim
  [lazyvim]=install_lazyvim
  [tmux]=install_tmux_tpm
  [zoxide]=install_zoxide
  [ripgrep_fd]=install_ripgrep_fd
  [eza]=install_eza
  [brew_fzf]=install_brew_fzf
  [starship]=install_starship
  [lazygit]=install_lazygit
  [wslu]=install_wslu
  [docker]=install_docker
  [lazydocker]=install_lazydocker
  [stow]=install_stow_dotfiles
)

show_checklist_dialog() {
  local checklist_args=()
  for key in "${STEP_ORDER[@]}"; do
    checklist_args+=("$key" "${STEPS[$key]}" "on")
  done

  local choices
  choices=$(dialog --stdout --checklist "Select components to install:" 22 60 14 "${checklist_args[@]}")
  local exit_code=$?

  clear
  if [ $exit_code -ne 0 ]; then
    echo "Installation cancelled."
    exit 0
  fi
  echo "$choices"
}

show_checklist_fallback() {
  local selected=()
  local states=()
  local skip_pauses="off"
  for key in "${STEP_ORDER[@]}"; do
    states+=("on")
  done

  while true; do
    clear >/dev/tty
    echo "" >/dev/tty
    echo "  Select components to install (toggle with number, Enter to confirm):" >/dev/tty
    echo "  ==================================================================" >/dev/tty
    echo "" >/dev/tty
    for i in "${!STEP_ORDER[@]}"; do
      local key="${STEP_ORDER[$i]}"
      local mark="[x]"
      if [ "${states[$i]}" = "off" ]; then
        mark="[ ]"
      fi
      printf "    %2d) %s %s\n" $((i + 1)) "$mark" "${STEPS[$key]}" >/dev/tty
    done
    echo "" >/dev/tty
    local skip_mark="[ ]"
    if [ "$skip_pauses" = "on" ]; then skip_mark="[x]"; fi
    echo "     s) $skip_mark Skip pauses between steps" >/dev/tty
    echo "" >/dev/tty
    echo "    a) Toggle all    Enter) Confirm selection    q) Quit" >/dev/tty
    echo "" >/dev/tty
    read -rp "  > " input </dev/tty >/dev/tty

    if [ -z "$input" ]; then
      break
    elif [ "$input" = "q" ]; then
      echo "Installation cancelled." >/dev/tty
      exit 0
    elif [ "$input" = "s" ]; then
      if [ "$skip_pauses" = "on" ]; then
        skip_pauses="off"
      else
        skip_pauses="on"
      fi
    elif [ "$input" = "a" ]; then
      local any_on="false"
      for state in "${states[@]}"; do
        if [ "$state" = "on" ]; then any_on="true"; break; fi
      done
      local new_state="on"
      if [ "$any_on" = "true" ]; then new_state="off"; fi
      for i in "${!states[@]}"; do
        states[$i]="$new_state"
      done
    elif [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 1 ] && [ "$input" -le ${#STEP_ORDER[@]} ]; then
      local idx=$((input - 1))
      if [ "${states[$idx]}" = "on" ]; then
        states[$idx]="off"
      else
        states[$idx]="on"
      fi
    fi
  done

  selected=()
  for i in "${!STEP_ORDER[@]}"; do
    if [ "${states[$i]}" = "on" ]; then
      selected+=("${STEP_ORDER[$i]}")
    fi
  done

  if [ "$skip_pauses" = "on" ]; then
    echo "SKIP_PAUSES ${selected[*]}"
  else
    echo "${selected[*]}"
  fi
}

show_checklist() {
  if command -v dialog >/dev/null 2>&1; then
    show_checklist_dialog
  else
    show_checklist_fallback
  fi
}

main() {
  local selected
  selected=$(show_checklist)

  if [ -z "$selected" ]; then
    echo "Nothing selected. Exiting."
    exit 0
  fi

  # Check for skip pauses flag
  if [[ "$selected" == SKIP_PAUSES* ]]; then
    SKIP_PAUSES="true"
    selected="${selected#SKIP_PAUSES }"
  fi

  for key in ${selected//\"/}; do
    run_step "${STEPS[$key]}" "${STEP_FUNCS[$key]}"
  done

  clear
  echo ""
  echo "========================================="
  echo "  Installation finished!"
  echo "========================================="
  echo ""
  echo "Log saved at: $LOGFILE"
  echo ""
  echo "Reminder for Windows users:"
  echo "  - Install win32yank for clipboard support in Neovim + tmux."
  echo "  - Set Windows Terminal font to JetBrainsMono Nerd Font."
  echo ""
  echo "Please restart your shell or run: source ~/.bashrc (or appropriate shell config)"
  echo ""
}

main
