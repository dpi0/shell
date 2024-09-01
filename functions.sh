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
    if command -v wl-copy &>/dev/null; then
        echo "$BUFFER" | wl-copy
    else
        echo "Error! Couldn't copy current line. wl-copy not present"
    fi
}
speedtest(){
	curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
}

f() {
    search_term="$1"

    SELECTED_FILE=$(
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
        echo "$SELECTED_FILE" | wl-copy
        echo "$SELECTED_FILE"
    fi
}

s() {
    search_term="$1"

        SELECTED_FILE=$(
            fd --type f --hidden --follow --search-path /data --search-path /home/dpi0 --exclude '**/.cache' --exclude '**/.Trash-1000' --color=always | fzf \
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
        "png" | "jpg" | "jpeg")
            loupe "$SELECTED_FILE"
            ;;
        "mp4" | "mkv" | "gif")
            mpv "$SELECTED_FILE"
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

        # Print the selected file value to stdout
        echo "$SELECTED_FILE" | wl-copy
        echo "$SELECTED_FILE"
    fi
}

# cd into dir
ff() {
	local selected_file
	selected_file=$(
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

ss() {
    local search_term
    search_term="$1"

    local selected_file
    selected_file=$(
        fd --type f --hidden --follow --search-path /data --search-path /home/dpi0 --exclude '**/.cache' --exclude '**/.Trash-1000' --color=always | fzf \
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
	paru -Slq | fzf -q "$1" -m --preview 'paru -Si {1}' | xargs -ro paru -S
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

