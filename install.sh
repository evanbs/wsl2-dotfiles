#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { echo -e "\033[0;34m[wsl2-dotfiles]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[wsl2-dotfiles]\033[0m $*"; }
warn() { echo -e "\033[0;33m[wsl2-dotfiles]\033[0m $*"; }

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backup: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  ok "Linked: $dst"
}

log "Aplicando configs do host WSL2..."

link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

ok "Pronto!"
