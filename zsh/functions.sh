lfs() {
  sudo yazi
}

copydir() {
  # Check if wl-copy is installed
  if command -v wl-copy &> /dev/null; then
    print -n $PWD | wl-copy
  else
    echo "wl-copy is not installed. Cannot copy current directory."
  fi
}

copylastcommand() {
  # Check if wl-copy is installed
  if command -v wl-copy &> /dev/null; then
    fc -ln -1 | tr -d '\n' | wl-copy
  else
    echo "wl-copy is not installed. Cannot copy last command."
  fi
}

copybuffer() {
  # You've already implemented the check here!
  if command -v wl-copy &> /dev/null; then
    echo "$BUFFER" | wl-copy
  else
    echo "Error! Couldn't copy current line. wl-copy not present"
  fi
}

count_files() {
  local dir="${1:-$(pwd)}"
  local group=false

  if [ "$1" = "-g" ] || [ "$1" = "--group" ]; then
    group=true
    dir="${2:-$(pwd)}"
  fi

  if $group; then
    fd -H -t f . "$dir" | awk -F. '{ext = $NF; if (ext != $0) {count[ext]++}} END {for (ext in count) print ext, count[ext]}'
  else
    fd -H . "$dir" | wc -l
  fi
}

speedtest_curl() {
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
}

f() {
  search_term="$1"

  SELECTED_FILE=$(
    fd --type f --hidden --follow --color=always \
      --exclude ".local" \
      --exclude ".rustup" \
      --exclude "node_modules" \
      --exclude ".cargo" \
      --exclude ".continue" \
      --exclude ".cargo" \
      --exclude ".mozilla" \
      --exclude "go/pkg/mod" \
      --exclude "Code/User" \
      --exclude ".git" \
      --exclude ".npm" \
      --exclude ".cache" |
      fzf \
        --query="$search_term" \
        --exact \
        --extended \
        --preview="bat --style=numbers --color=always --line-range :500 {}" \
        --preview-window="right:50%" \
        --ansi
  )

  if [ -n "$SELECTED_FILE" ]; then
    file_extension="${SELECTED_FILE##*.}"

    case "$file_extension" in
      "pdf")
        evince "$SELECTED_FILE"
        ;;
      "txt" | "py" | "rs" | "go" | "md")
        if command -v nvim &> /dev/null; then
          nvim "$SELECTED_FILE"
        else
          vim "$SELECTED_FILE"
        fi
        ;;
      *)
        if command -v nvim &> /dev/null; then
          nvim "$SELECTED_FILE"
        else
          vim "$SELECTED_FILE"
        fi
        ;;
    esac

    # Check if wl-copy is installed
    if command -v wl-copy &> /dev/null; then
      # Print the selected file value to clipboard
      echo "$SELECTED_FILE" | wl-copy
    fi

    # Print the selected file value to stdout
    echo "$SELECTED_FILE"
  fi
}

# s() {
#   search_term="$1"
#
#   SELECTED_FILE=$(
#     fd --type f --hidden --follow --color=always \
#       --exclude ".local" \
#       --exclude ".rustup" \
#       --exclude "node_modules" \
#       --exclude ".cargo" \
#       --exclude ".continue" \
#       --exclude ".cargo" \
#       --exclude ".mozilla" \
#       --exclude "go/pkg/mod" \
#       --exclude "Code/User" \
#       --exclude ".git" \
#       --exclude ".npm" \
#       --exclude ".cache" |
#       fzf \
#         --query="$search_term" \
#         --exact \
#         --extended \
#         --preview="bat --style=numbers --color=always --line-range :500 {}" \
#         --preview-window="right:50%" \
#         --ansi
#   )
#
#   if [ -n "$SELECTED_FILE" ]; then
#     file_extension="${SELECTED_FILE##*.}"
#
#     case "$file_extension" in
#       "pdf")
#         evince "$SELECTED_FILE"
#         ;;
#       "png" | "jpg" | "jpeg")
#         loupe "$SELECTED_FILE"
#         ;;
#       "mp4" | "mkv" | "gif")
#         mpv "$SELECTED_FILE"
#         ;;
#       "txt" | "py" | "rs" | "go" | "md")
#         if command -v nvim &> /dev/null; then
#           nvim "$SELECTED_FILE"
#         else
#           vim "$SELECTED_FILE"
#         fi
#         ;;
#       *)
#         if command -v nvim &> /dev/null; then
#           nvim "$SELECTED_FILE"
#         else
#           vim "$SELECTED_FILE"
#         fi
#         ;;
#     esac
#
#     # Print the selected file value to stdout
#     echo "$SELECTED_FILE" | wl-copy
#     echo "$SELECTED_FILE"
#   fi
# }

# cd into dir
ff() {
  local selected_file
  selected_file=$(
    fd --type f --hidden --follow --color=always \
      --exclude ".local" \
      --exclude ".rustup" \
      --exclude "node_modules" \
      --exclude ".cargo" \
      --exclude ".continue" \
      --exclude ".cargo" \
      --exclude ".mozilla" \
      --exclude "go/pkg/mod" \
      --exclude "Code/User" \
      --exclude ".git" \
      --exclude ".npm" \
      --exclude ".cache" |
      fzf \
        --query="$search_term" \
        --exact \
        --extended \
        --preview="bat --style=numbers --color=always --line-range :500 {}" \
        --preview-window="right:50%" \
        --ansi
  )
  if [[ -n $selected_file ]]; then
    local parent_dir
    parent_dir=$(dirname "$selected_file")
    cd "$parent_dir" || echo "Failed to change directory"
  else
    echo "No file selected"
  fi
}

# ss() {
#   local search_term
#   search_term="$1"
#
#   local selected_file
#   selected_file=$(
#     fd --type f --hidden --follow --color=always \
#       --exclude ".local" \
#       --exclude ".rustup" \
#       --exclude "node_modules" \
#       --exclude ".cargo" \
#       --exclude ".continue" \
#       --exclude ".cargo" \
#       --exclude ".mozilla" \
#       --exclude "go/pkg/mod" \
#       --exclude "Code/User" \
#       --exclude ".git" \
#       --exclude ".npm" \
#       --exclude ".cache" |
#       fzf \
#         --query="$search_term" \
#         --exact \
#         --extended \
#         --preview="bat --style=numbers --color=always --line-range :500 {}" \
#         --preview-window="right:50%" \
#         --ansi
#   )
#
#   if [[ -n $selected_file ]]; then
#     local parent_dir
#     parent_dir=$(dirname "$selected_file")
#     cd "$parent_dir" || echo "Failed to change directory"
#   else
#     echo "No file selected"
#   fi
# }

remove_variable_from_history() {
  local var_to_remove="$1"
  local temp_file=$(mktemp)

  # Use ripgrep to find lines containing the variable and list them
  local found_lines=$(rg --color=always "$var_to_remove" ~/.zsh_history)

  if [[ -z "$found_lines" ]]; then
    echo "No lines containing '$var_to_remove' found in ~/.zsh_history."
    return
  fi

  # Display the found lines
  echo "The following lines will be deleted:"
  echo "$found_lines"

  # Use ripgrep to exclude lines containing the variable and write to the temporary file
  rg -v "$var_to_remove" ~/.zsh_history > "$temp_file"

  # Overwrite the original history file with the cleaned version
  mv "$temp_file" ~/.zsh_history

  echo "Deleted $(echo "$found_lines" | wc -l) lines containing '$var_to_remove'."

  # Reload the shell
  exec zsh
}

fh() {
  selected_command=$(history -E 1 | sort -k1,1nr | fzf | awk '{$1=""; $2=""; $3=""; print $0}' | sed 's/^[ \t]*//')

  # Check if wl-copy is installed
  if command -v wl-copy &> /dev/null; then
    echo "$selected_command" | wl-copy
  else
    echo "wl-copy is not installed. Cannot copy to clipboard."
  fi
}

finh() {
  cat /var/log/pacman.log | grep -E "\[ALPM\] (installed|removed|upgraded|upgraded|downgraded)" | awk '{print $1, $2, $3, $4, $5, $6}' | sort -r | fzf
}

# search all installed packages
fin() {
  pacman -Qq | fzf --preview='pacman -Qi {}'
}

in() {
  pacman -Slq | fzf -q "$1" -m --preview 'pacman -Si {1}' | xargs -ro pacman -S
}

extract() {
  if [ -f "$1" ]; then
    local target_dir="${2:-.}"

    # Create the target directory if it doesn't exist
    if [ ! -d "$target_dir" ]; then
      mkdir -p "$target_dir"
    fi

    case "$1" in
      *.zip) unzip "$1" -d "$target_dir" ;;
      *.tar.gz) tar -xzvf "$1" -C "$target_dir" ;;
      *.tar.xz) tar -xJf "$1" -C "$target_dir" ;;
      *.tar.bz2) tar -xjvf "$1" -C "$target_dir" ;;
      *.tar) tar -xvf "$1" -C "$target_dir" ;;
      *) echo "Unsupported format" ;;
    esac

  else
    echo "'$1' is not a valid file"
  fi
}

compress() {
  if [ "$#" -lt 3 ]; then
    echo "Usage: compress_files <file1> <file2> ... <output-file>"
    echo "   or: compress_files * <output-file>"
    return 1
  fi

  local files=()
  local output_file=""

  # Check if the first argument is an asterisk (*)
  if [ "$1" = "*" ]; then
    files=("${@:2:$#-2}")
  else
    files=("${@:1:$#-1}")
  fi

  output_file="${!#}"

  # Check if 'zip' command is available
  if command -v zip &> /dev/null; then
    local extension=".zip"
    zip -r "$output_file$extension" "${files[@]}"
  else
    local extension=".tar.gz"
    eval "tar -czvf '$output_file$extension' ${files[@]}"
  fi

  echo "Compression operation completed successfully. Output file: $output_file$extension"
}

# launch-waybar(){
#     CONFIG_FILES="$DOTFILES/waybar/config.jsonc $DOTFILES/waybar/style.css "
#
#     #$DOTFILES/waybar/config2.jsonc
#
#     trap "killall waybar" EXIT
#
#     while true; do
#         waybar &
#         inotifywait -e create,modify $CONFIG_FILES
#         killall waybar
#     done
# }
#

# Function to create or open a note in $HOME/Notes/docs directory
note() {
  local note_path="$HOME/Notes/docs/$1.md"
  if [[ -f "$note_path" ]]; then
    # If the note exists, open it in neovim
    nvim "$note_path"
  else
    # Create a new note and open it in neovim
    mkdir -p "$(dirname "$note_path")" # Ensure the directory exists
    touch "$note_path"
    nvim "$note_path"
  fi
}

# Function to enable autocompletion for the `note` command
_note_autocomplete() {
  local cur_word="${1}" # Current word typed
  local notes_dir="$HOME/Notes/docs"

  # List all files and directories in the notes directory
  local suggestions=($(find "$notes_dir" -type d -mindepth 1 -maxdepth 2 | sed "s|$notes_dir/||"))

  # Add files without `.md` extension to the suggestions
  suggestions+=($(find "$notes_dir" -type f -name "*.md" | sed "s|$notes_dir/||" | sed "s|\.md$||"))

  # Provide suggestions for autocomplete
  compadd "${suggestions[@]}"
}

# Bind autocompletion to the note function
compdef _note_autocomplete note

function sesh-sessions() {
  {
    exec < /dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle -N sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions
