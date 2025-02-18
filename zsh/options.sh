#!/usr/bin/env zsh

HISTFILE=~/.zsh_history # location of the history file
HISTFILESIZE=1000000000 # history limit of the file on disk
HISTSIZE=1000000000 # current session's history limit
SAVEHIST=500000 # zsh saves this many lines from the in-memory history list to the history file upon shell exit
HISTTIMEFORMAT="%d/%m/%Y %H:%M] "

setopt INC_APPEND_HISTORY # history file is updated immediately after a command is entered
setopt SHARE_HISTORY # allows multiple Zsh sessions to share the same command history 
setopt EXTENDED_HISTORY # records the time when each command was executed along with the command itself
setopt APPENDHISTORY # ensures that each command entered in the current session is appended to the history file immediately after execution

setopt autocd

fpath+=("$HOME/zsh/completion")
autoload -Uz _rmi
autoload -Uz compinit && compinit

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.dotfiles/scripts"
export PATH="$PATH:$HOME/zsh/scripts"
export PATH="$PATH:$HOME/Applications"
export PATH="$PATH:$HOME/.deno/bin"
export PATH="$PATH:$HOME/.nix-profile/bin"

export CONFIG="$HOME/.config"
export SCRIPTS="$DOTFILES/scripts"
export LOCALBIN="$HOME/.local/bin"
export VOLUMES="$HOME/docker_volumes"
export EDITOR="/usr/bin/nvim"
export GPG_TTY=$(tty)
export PIPENV_VENV_IN_PROJECT=0
if command -v vivid &>/dev/null; then
    export LS_COLORS="$(vivid generate molokai)"
fi
#export WALLPAPER="$HOME/Downloads/starligher-spaceship-sunset.jpeg"

if command -v go &> /dev/null; then
  export PATH=$PATH:$(go env GOPATH)/bin
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd j)"
fi

export GOPATH="$HOME/go"

# load the environment variables from the .env file
# export $(grep -v '^#' ~/.dotfiles/.env | xargs)

# --- FZF ---
# export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_DEFAULT_COMMAND="fd --type file --hidden --no-ignore --color=always --exclude .local/state --exclude .Trash-1000 --exclude node-modules --exclude .git --exclude .cargo --exclude .cache"
# fd --type file --hidden --no-ignore --color=always --exclude .local/state --exclude .Trash-1000 --exclude node-modules --exclude .git --exclude .cargo
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --bind "ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)"'
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# --- RUBY GEMS ---
# export GEM_HOME="$(gem env user_gemhome)"
# export PATH="$PATH:$GEM_HOME/bin"
