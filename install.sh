#!/bin/bash

set -e # Exit immediately on error

SHELL_DIR="$HOME/sh"
CONFIG_DIR="$HOME/.config"

link() {
  SRC="$1"
  DEST="$2"
  TIMESTAMP=$(date +"%d-%B-%Y_%H-%M-%S")
  BACKUP_PATH="${DEST}_backup_$TIMESTAMP"

  # If it's already the correct symlink, do nothing
  if [ -L "$DEST" ] && [ "$(readlink "$DEST")" = "$SRC" ]; then
    echo "✅ Already correctly linked: $DEST"
    return
  fi

  # If a regular file/directory exists, back it up
  if [ -e "$DEST" ] || [ -L "$DEST" ]; then
    echo "🗂️ Backing up existing: $DEST -> $BACKUP_PATH"
    mv "$DEST" "$BACKUP_PATH"
  fi

  mkdir -p "$(dirname "$DEST")"
  ln -s "$SRC" "$DEST"
  echo "🔗 Symlinked: $SRC -> $DEST"
}

mkdir -p "$CONFIG_DIR/btop"

link "$SHELL_DIR/.tmux.conf" "$HOME/.tmux.conf"
link "$SHELL_DIR/.vimrc" "$HOME/.vimrc"
link "$SHELL_DIR/btop.conf" "$CONFIG_DIR/btop/btop.conf"
link "$SHELL_DIR/git/.gitattributes" "$HOME/.gitattributes"
link "$SHELL_DIR/git/.gitconfig" "$HOME/.gitconfig"
link "$SHELL_DIR/nvim" "$CONFIG_DIR/nvim"
link "$SHELL_DIR/yazi" "$CONFIG_DIR/yazi"
link "$SHELL_DIR/lazygit/config.yml" "$CONFIG_DIR/lazygit/config.yml"
link "$SHELL_DIR/zsh/.zshrc" "$HOME/.zshrc"

echo "✅ Dotfiles installation complete."
