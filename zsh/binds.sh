#!/use/bin/env zsh

# -----------------------------------------
# use showkey -a to get the shortcut name
# or cat -v
# -----------------------------------------

bindkey -e # sets the ZLE to use Emacs key bindings


go_forward_in_words() {
    local WORDCHARS=${WORDCHARS//[-\/,.:;_=]}
    zle forward-word
}

go_back_in_words() {
    local WORDCHARS=${WORDCHARS//[-\/,.:;_=]}
    zle backward-word
}

delete_word() {
    local WORDCHARS=${WORDCHARS//[-\/,.:;_=]}
    zle backward-delete-word
}

zle -N go_forward_in_words
bindkey '^[[1;5C' go_forward_in_words

zle -N go_back_in_words
bindkey '^[[1;5D' go_back_in_words

zle -N delete_word
bindkey '^[^?' delete_word

zle -N copybuffer
bindkey "^O" copybuffer

zle -N copydir
bindkey "^Y" copydir

zle -N copylastcommand
bindkey "^T" copylastcommand

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# zle -N f
# bindkey "^f" f

# zle -N ff
# bindkey "^[f" ff

# zle -N sudo-command-line
# bindkey "\e\e" sudo-command-line

bindkey -s '^[v' 'v .^M'
bindkey -s '^[c' 'code .^M'

# Bind Shift+HJKL to cursor movements
#bindkey -s '^[H' '^[OA'  # Shift+H -> Up
#bindkey -s '^[J' '^[OB'  # Shift+J -> Down
#bindkey -s '^[K' '^[OC'  # Shift+K -> Right
#bindkey -s '^[L' '^[OD'  # Shift+L -> Left

# Bind Ctrl+k to history up (previous command)
bindkey '^k' up-line-or-history

# Bind Ctrl+j to history down (next command)
bindkey '^j' down-line-or-history
