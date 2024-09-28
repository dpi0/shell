#!/usr/bin/env bash

# Define color codes for better readability
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
RESET='\033[0m'

# Default values for command-line arguments
CHANGE_SHELL=false
REMOVE_SNAP=false

# Global variables frequently edited
REPO_DIR="$HOME/repos"
CONFIG_DIR="$HOME/.config"
ZSH_DIR="$HOME/zsh"
POWERLEVEL10K_DIR="$HOME/powerlevel10k"
TMUX_PLUGIN_DIR="$HOME/.tmux/plugins/tpm"

# URLs for repositories
POWERLEVEL10K_REPO="https://github.com/romkatv/powerlevel10k.git"
TMUX_PLUGIN_REPO="https://github.com/tmux-plugins/tpm"
ZSH_REPO="https://github.com/dpi0/zsh"

# Package lists
PACKAGES_APT=(zsh tmux git gpg btop eza fzf gdu zip unzip gh duf)
PACKAGES_PACMAN=(zsh tmux git gpg btop eza fzf fd gdu bat zip unzip duf ctop zoxide rsync)

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --change-shell) CHANGE_SHELL=true ;;
        --remove-snap) REMOVE_SNAP=true ;;
        *) echo -e "${RED}Unknown parameter passed: $1${RESET}"; exit 1 ;;
    esac
    shift
done

# Function to identify the system
identify_system() {
    if [ -f /etc/os-release ]; then
        # Freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # Linux Standard Base
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    else
        # Unable to identify system
        echo -e "${RED}Unable to identify system. Please install manually.${RESET}"
        exit 1
    fi
}

# Function to install packages
install_package() {
    local package=$1
    if command -v "$package" &> /dev/null; then
        echo -e "${YELLOW}$package is already installed. Skipping...${RESET}"
    else
        echo -e "${GREEN}$package is not installed. Installing...${RESET}"
        case "$OS" in
            "Ubuntu"|"Debian")
                sudo apt update && sudo apt install -y "$package"
                ;;
            "Arch Linux")
                sudo pacman -Syu "$package" --noconfirm
                ;;
            *)
                echo -e "${RED}Unsupported system. Please install $package manually.${RESET}"
                exit 1
                ;;
        esac
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to install $package.${RESET}"
            exit 1
        fi
        echo -e "${GREEN}$package installation completed!${RESET}"
    fi
}

# Function to clone repositories
clone_repo() {
    local repo_url=$1
    local target_dir=$2
    if [ ! -d "$target_dir" ]; then
        echo -e "${GREEN}Cloning $target_dir...${RESET}"
        git clone --depth=1 "$repo_url" "$target_dir"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to clone $target_dir.${RESET}"
            exit 1
        fi
        echo -e "${GREEN}$target_dir cloned successfully!${RESET}"
    else
        echo -e "${YELLOW}$target_dir already cloned. Skipping...${RESET}"
    fi
}

# Function to remove Snap on Ubuntu
remove_snap() {
    if [ "$OS" == "Ubuntu" ] && [ "$REMOVE_SNAP" = true ]; then
        echo -e "${YELLOW}Removing Snap...${RESET}"
        sudo snap list
        sudo snap remove --purge $(snap list | awk '{if(NR>1)print $1}')
        sudo apt remove --purge snapd -y
        sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd
        echo -e "${GREEN}Snap removed successfully!${RESET}"
    fi
}

# Function to install utilities
install_utilities() {
    case "$OS" in
        "Ubuntu"|"Debian")
            for package in "${PACKAGES_APT[@]}"; do
                install_package "$package"
            done
            # Additional checks for specific packages
            for pkg in fd-find bat neovim ripgrep; do
                if ! command -v "${pkg%*-find}" &> /dev/null; then
                    install_package "$pkg"
                fi
            done
            # Install ripgrep-all manually
            if ! command -v rga &> /dev/null; then
                local latest_version=$(curl -s https://api.github.com/repos/phiresky/ripgrep-all/releases/latest | jq -r '.tag_name')
                curl -s -L "https://github.com/phiresky/ripgrep-all/releases/download/$latest_version/ripgrep_all-$latest_version-x86_64-unknown-linux-musl.tar.gz" -o ripgrep_all.tar.gz
                tar -xvf ripgrep_all.tar.gz
                cp "ripgrep_all-$latest_version-x86_64-unknown-linux-musl/rga" "$HOME/.local/bin/"
                cp "ripgrep_all-$latest_version-x86_64-unknown-linux-musl/rga-fzf" "$HOME/.local/bin/"
            fi
            ;;
        "Arch Linux")
            for package in "${PACKAGES_PACMAN[@]}"; do
                install_package "$package"
            done
            # Additional checks for specific packages
            for pkg in gh nvim rg rga; do
                if ! command -v "$pkg" &> /dev/null; then
                        install_package "neovim"
                        install_package "ripgrep"
                        install_package "ripgrep-all"
                        install_package "github-cli"
                fi
            done
            ;;
    esac

    # Install zoxide if not already installed
    if ! command -v zoxide &> /dev/null; then
        echo -e "${YELLOW}zoxide not found. Installing...${RESET}"
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
        echo -e "${GREEN}zoxide installed successfully!${RESET}"
    else
        echo -e "${YELLOW}zoxide already installed, skipping...${RESET}"
    fi

    # Create ~/.local/bin directory
    mkdir -p "$HOME/.local/bin"

    # Create symlinks for fd and bat if necessary
    for cmd in fd bat; do
        if ! command -v "$cmd" &> /dev/null; then
            local src=$(which "${cmd}find" || which "${cmd}cat")
            ln -s "$src" "$HOME/.local/bin/$cmd"
            echo -e "${GREEN}Symlink created for $cmd successfully!${RESET}"
        else
            echo -e "${YELLOW}$cmd already installed, skipping...${RESET}"
        fi
    done
}

# Function to install Docker
install_docker() {
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker is already installed. Skipping...${RESET}"
    else
        case "$OS" in
            "Ubuntu"|"Debian")
                echo -e "${GREEN}Installing Docker...${RESET}"
                curl -fsSL https://get.docker.com | sh
                sudo usermod -aG docker $USER
                newgrp docker
                sudo systemctl enable docker.service
                sudo systemctl start docker.service
                echo -e "${GREEN}Docker installation completed!${RESET}"
                ;;
            "Arch Linux")
                echo -e "${GREEN}Installing Docker on Arch Linux...${RESET}"
                install_package "docker"
                install_package "docker-compose"
                sudo usermod -aG docker $USER
                newgrp docker
                sudo systemctl enable docker.service
                sudo systemctl start docker.service
                echo -e "${GREEN}Docker installation completed on Arch Linux!${RESET}"
                ;;
            *)
                echo -e "${RED}Docker installation is only supported for Ubuntu, Debian, and Arch Linux.${RESET}"
                ;;
        esac
    fi
}

symlink_files() {
    files_to_link=(
        ".zshrc:$HOME"
        ".tmux.conf:$HOME"
        "btop.conf:$CONFIG_DIR/btop"
        "yazi:$CONFIG_DIR/yazi"
    )
    
    # Loop through each file and its target directory
    for file_info in "${files_to_link[@]}"; do
        file=$(echo "$file_info" | cut -d':' -f1)
        target_dir=$(echo "$file_info" | cut -d':' -f2)
        
        # Check if the file already exists in the target directory
        if [ -e "$target_dir/$file" ]; then
            echo -e "${YELLOW}$file already exists. Creating a backup...${RESET}"
            mv "$target_dir/$file" "$target_dir/$file.bak"
        fi
        
        # Create the symlink
        ln -s "$ZSH_DIR/$file" "$target_dir/$file"
        echo -e "${GREEN}$file symlink created successfully!${RESET}"
    done
}

# Function to set up shell environment
setup_shell() {
    clone_repo "$POWERLEVEL10K_REPO" "$POWERLEVEL10K_DIR"
    clone_repo "$TMUX_PLUGIN_REPO" "$TMUX_PLUGIN_DIR"
    clone_repo "$ZSH_REPO" "$ZSH_DIR"

    mkdir -p $HOME/.config/btop
    symlink_files
    
    if [[ "$SHELL" != *"zsh" ]] && [ "$CHANGE_SHELL" = true ]; then
        echo -e "${YELLOW}Changing default shell to zsh...${RESET}"
        sudo usermod -s /usr/bin/zsh $USER
        echo -e "${GREEN}Default shell changed to zsh successfully!${RESET}"
    else
        echo -e "${YELLOW}zsh is already the default shell, Skipping...${RESET}"
    fi
}

# Main execution
identify_system
remove_snap
install_utilities
install_docker
setup_shell

echo -e "${GREEN}Starting new zsh session...${RESET}"
exec zsh -l
