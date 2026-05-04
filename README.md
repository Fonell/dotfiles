# Dotfiles

## Install

```bash
/bin/bash -c "$(curl -fsSL https://github.com/Fonell/dotfiles/raw/master/install.sh)"
```

## What gets installed

| Tool                                                    | Method                            |
| ------------------------------------------------------- | --------------------------------- |
| git, curl, stow, tmux, ripgrep, wslu                    | apt                               |
| neovim                                                  | built from source                 |
| LazyVim                                                 | git clone → `~/.config/nvim`      |
| tmux TPM                                                | git clone → `~/.tmux/plugins/tpm` |
| Homebrew                                                | official install script           |
| eza, lazygit, lazydocker, starship, fd, fzf, zoxide, gh | brew                              |
| Docker                                                  | get.docker.com                    |
| dotfiles                                                | stow                              |

## Notes

**Docker** — after install, re-login or run `newgrp docker` for group changes to take effect.
If systemd is not enabled in WSL, start the daemon manually with `sudo dockerd`.
To enable systemd, add to `/etc/wsl.conf` and run `wsl --shutdown`:

```ini
[boot]
systemd=true
```

**GitHub auth** — the script runs `gh auth login` interactively. Complete the browser flow when prompted before the script continues to clone your dotfiles.

**Neovim** — built from source, takes several minutes.

**Shell** — restart your shell or run `source ~/.bashrc` after the script completes.
