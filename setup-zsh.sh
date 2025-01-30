#!/usr/bin/env bash

mkdir -p ~/.local/bin

CONFIG=$HOME/.config

ln -s $HOME/zsh/nvim $CONFIG/
ln -s $HOME/zsh/yazi $CONFIG/
ln -s $HOME/zsh/btop.conf $CONFIG/btop/btop.conf
ln -s $HOME/zsh/.zshrc $HOME/.zshrc
ln -s $HOME/zsh/.tmux.conf $HOME/.tmux.conf
