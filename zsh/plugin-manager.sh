#!/usr/bin/env zsh

function plugin-clone {
  local repo plugdir initfile initfiles=()
  ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  
  for repo in "$@"; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) && ln -sf $initfiles[1] $initfile
    fi
  done
}

function plugin-source {
  local plugdir
  ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  for plugdir in $@; do
    [[ $plugdir = /* ]] || plugdir=$ZPLUGINDIR/$plugdir
    fpath+=$plugdir
    local initfile=$plugdir/${plugdir:t}.plugin.zsh
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

function plugin-update {
  ZPLUGINDIR=${ZPLUGINDIR:-$HOME/.config/zsh/plugins}
  for d in $ZPLUGINDIR/*/.git(/); do
    echo "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
    echo "------------"
  done
}

# to remove a plugin
# rm -rfi $ZPLUGINDIR/<plugin-dir-name>

repos=(
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
  MichaelAquilina/zsh-you-should-use
  wfxr/forgit
  Aloxaf/fzf-tab
  zdharma-continuum/fast-syntax-highlighting
  # jeffreytse/zsh-vi-mode
)

# ORDER MATTERS HERE!
# to get lang supported plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins-Overview
plugins=(
  forgit
  fzf-tab
  zsh-you-should-use
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  fast-syntax-highlighting
  # zsh-vi-mode
)

plugin-clone $repos
plugin-source $plugins
