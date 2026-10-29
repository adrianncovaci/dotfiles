#!/usr/bin/env bash
# Symlink these dotfiles into place. Safe to re-run: anything already there that
# isn't our symlink is moved aside to <name>.bak.<timestamp>.
# Tools themselves come from the nix flake: `nix profile add ~/dotfiles`.
set -euo pipefail

DOT="$(cd "$(dirname "$0")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$src" ]; then
      echo "ok      $dst"
      return
    fi
    rm "$dst"
  elif [ -e "$dst" ]; then
    local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$bak"
    echo "backup  $dst -> $bak"
  fi
  ln -s "$src" "$dst"
  echo "linked  $dst -> $src"
}

link zsh/zshrc     "$HOME/.zshrc"
link git           "$CFG/git"
link nix           "$CFG/nix"
link nvim          "$CFG/nvim"
link tmux          "$CFG/tmux"
link sesh          "$CFG/sesh"
link delta         "$CFG/delta"
link starship.toml "$CFG/starship.toml"
link claude/statusline.sh "$HOME/.claude/statusline.sh"

# Claude Code rewrites settings.json itself, so merge our key in instead of linking it
settings="$HOME/.claude/settings.json"
jq="$(command -v jq || echo "$HOME/.nix-profile/bin/jq")"
if [ -x "$jq" ]; then
  [ -s "$settings" ] || echo '{}' > "$settings"
  tmp="$(mktemp)"
  "$jq" '.statusLine = {type: "command", command: "~/.claude/statusline.sh", refreshInterval: 30}' "$settings" > "$tmp"
  mv "$tmp" "$settings"
  echo "set     statusLine in $settings"
else
  echo "skip    statusLine: no jq yet (run 'nix profile add ~/dotfiles', then re-run this)"
fi

if [ "$(uname)" = Darwin ]; then
  link alacritty "$CFG/alacritty"
  link macchina  "$CFG/macchina"
elif [ "${DESKTOP:-0}" = 1 ]; then
  link alacritty "$CFG/alacritty"
  link i3        "$CFG/i3"
  link dunst     "$CFG/dunst"
  link flameshot "$CFG/flameshot"
fi

# oh-my-zsh and the one plugin that doesn't ship with it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone -q --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  echo "cloned  oh-my-zsh"
fi
plug="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$plug" ]; then
  git clone -q --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$plug"
  echo "cloned  zsh-autosuggestions"
fi
