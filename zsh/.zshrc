if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# Change prompt if the hostname is not arch
if [[ "$(cat /etc/hostname)" != "arch" ]]; then
    PROMPT="%F{#009dff}%n%F{#00ff59}@%m %F{#ffea00}in %~ %F{reset}$ "
else
    # let it stay on top & READ THIS: for why this is so cool- https://github.com/romkatv/zsh-bench?tab=readme-ov-file#instant-prompt
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
	source $HOME/shell/zsh/powerlevel10k/powerlevel10k.zsh-theme
fi

export ZSHROOT="$HOME/shell/zsh"
export DOTFILES="$HOME/.dotfiles"

source $ZSHROOT/options.sh
source $ZSHROOT/alias.sh
source $ZSHROOT/functions.sh
source $ZSHROOT/binds.sh
source $ZSHROOT/themes/lean-p10k.zsh # same as ~/.p10k.zsh in the docs
# source $ZSHROOT/themes/robbby-russell-p10k.zsh
source $ZSHROOT/plugin-manager.sh
source $ZSHROOT/plugins/dirhistory.plugin.zsh
source $ZSHROOT/plugins/fzf-history-search.zsh

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
