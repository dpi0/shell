#!/usr/bin/env bash

# Identify the system
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
    echo "Unable to identify system. Please install manually."
    exit 1
fi

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
RESET='\033[0m'

# Function to install packages
install_package() {
    if command -v "$1" &> /dev/null; then
        echo -e "${YELLOW}$1 is already installed. Skipping...${RESET}"
    else
        echo -e "${GREEN}$1 is not installed. Installing...${RESET}"
        if [ "$OS" == "Ubuntu" ]; then
            sudo apt update && sudo apt install -y "$1"
            echo -e "${GREEN}$1 installation completed!${RESET}"
        elif [ "$OS" == "Arch Linux" ]; then
            sudo pacman -Syu "$1" --noconfirm
            echo -e "${GREEN}$1 installation completed!${RESET}"
        else
            echo -e "${RED}Unsupported system. Please install $1 manually.${RESET}"
            exit 1
        fi
    fi
}

# Function to clone repositories
clone_repo() {
    if [ ! -d "$2" ]; then
        echo -e "${GREEN}Cloning $2...${RESET}"
        git clone $1 $2
        echo -e "${GREEN}$2 cloned successfully!${RESET}"
    else
        echo -e "${YELLOW}$2 already cloned. Skipping...${RESET}"
    fi
}

# Ubuntu-specific Snap removal
if [ "$OS" == "Ubuntu" ]; then
    echo -e "${YELLOW}Ubuntu detected. Remove Snap? (y/n)${RESET}"
    read -r response
    if [[ $response =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Removing Snap...${RESET}"
        sudo snap list
        sudo snap remove --purge $(snap list | awk '{if(NR>1)print $1}')
        sudo apt remove --purge snapd -y
        sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd
        echo -e "${GREEN}Snap removed successfully!${RESET}"
    else
        echo -e "${YELLOW}Skipping Snap removal...${RESET}"
    fi
fi

# Install Aops
packages_apt=(zsh tmux git gpg btop eza fzf gdu zip unzip)
packages_pacman=(zsh tmux git gpg btop eza fzf fd gdu bat neovim zip unzip ripgrep ripgrep-all)

if [ "$OS" == "Ubuntu" ]; then
    for package in "${packages_apt[@]}"; do
        install_package "$package"
    done
    
    # Check for fdfind or fd
    if ! command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        install_package "fd-find"
    fi

    # Check for batcat or bat
    if ! command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        install_package "bat"
    fi

    # Check for nvim
    if ! command -v nvim &> /dev/null; then
        install_package "neovim"
    fi

    # Check for ripgrep
    if ! command -v rg &> /dev/null; then
        install_package "ripgrep"
    fi

    # Check for ripgrep-all
    if ! command -v rga &> /dev/null; then
        LATEST_VERSION=$(curl -s https://api.github.com/repos/phiresky/ripgrep-all/releases/latest | jq -r '.tag_name')
        curl -s -L https://github.com/phiresky/ripgrep-all/releases/download/$LATEST_VERSION/ripgrep_all-$LATEST_VERSION-x86_64-unknown-linux-musl.tar.gz -o ripgrep_all.tar.gz
        tar -xvf ripgrep_all.tar.gz
        cp ripgrep_all-$LATEST_VERSION-x86_64-unknown-linux-musl/rga $HOME/.local/bin/
        cp ripgrep_all-$LATEST_VERSION-x86_64-unknown-linux-musl/rga-fzf $HOME/.local/bin/
    fi
    
elif [ "$OS" == "Arch Linux" ]; then
    for package in "${packages_pacman[@]}"; do
        install_package "$package"
    done
fi

if ! command -v zoxide &> /dev/null && [ "$OS" != "Arch Linux" ]; then
  echo -e "${YELLOW}zoxide not found. Installing...${RESET}"
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  echo -e "${GREEN}zoxide installed successfully!${RESET}"
else
  echo -e "${YELLOW}zoxide already installed or Arch Linux system, skipping...${RESET}"
fi

echo -e "${YELLOW}Creating ~/.local/bin directory...${RESET}"
mkdir -p $HOME/.local/bin

if ! command -v fd &> /dev/null && [ "$OS" != "Arch Linux" ]; then
  echo -e "${YELLOW}fd not found. Creating symlink for fdfind...${RESET}"
  ln -s $(which fdfind) ~/.local/bin/fd
  echo -e "${GREEN}Symlink created successfully!${RESET}"
else
  echo -e "${YELLOW}fd already installed or Arch Linux system, skipping...${RESET}"
fi

if ! command -v bat &> /dev/null && [ "$OS" != "Arch Linux" ]; then
  echo -e "${YELLOW}bat not found. Creating symlink for bat...${RESET}"
  ln -s /usr/bin/batcat ~/.local/bin/bat
  echo -e "${GREEN}Symlink created successfully!${RESET}"
else
  echo -e "${YELLOW}bat already installed or Arch Linux system, skipping...${RESET}"
fi

echo -e "${GREEN}Utilities installed!${RESET}"

echo
# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker is already installed. Skipping...${RESET}"
else
    if [ "$OS" == "Ubuntu" ]; then
        # Ask for confirmation before installing Docker
        read -p "Install Docker? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Installing Docker...${RESET}"
            curl -fsSL https://get.docker.com | sh
            sudo usermod -aG docker $USER
            newgrp docker
            sudo systemctl enable docker.service
            sudo systemctl start docker.service
            echo -e "${GREEN}Docker installation completed!${RESET}"
        else
            echo -e "${RED}Docker installation cancelled.${RESET}"
        fi
    elif [ "$OS" == "Arch Linux" ]; then
        # Ask for confirmation before installing Docker on Arch Linux
        read -p "Install Docker on Arch Linux? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Installing Docker on Arch Linux...${RESET}"
            sudo pacman -Syu --noconfirm docker docker-compose
            sudo usermod -aG docker $USER
            newgrp docker
            sudo systemctl enable docker.service
            sudo systemctl start docker.service
            echo -e "${GREEN}Docker installation completed on Arch Linux!${RESET}"
        else
            echo -e "${RED}Docker installation cancelled.${RESET}"
        fi
    else
        echo -e "${RED}Docker installation is only supported for Ubuntu and Arch Linux.${RESET}"
    fi
fi

# Clone Powerlevel10k and TPM
echo
clone_repo "--depth=1 https://github.com/romkatv/powerlevel10k.git" "$HOME/powerlevel10k"
clone_repo "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
clone_repo "https://github.com/dpi0/zsh" "$HOME/zsh"

echo
if [ ! -e "$HOME/.zshrc" ]; then
  ln -s "$HOME/zsh/.zshrc" "$HOME/.zshrc"
else
  echo -e "${YELLOW}.zshrc symlink already exists, Skipping...${RESET}"
fi

if [ ! -e "$HOME/.tmux.conf" ]; then
  ln -s "$HOME/zsh/.tmux.conf" "$HOME/.tmux.conf"
else
  echo -e "${YELLOW}.tmux.conf symlink already exists, Skipping...${RESET}"
fi

if [ "$SHELL" != "/sbin/zsh" ] && [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/sbin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo -e "${YELLOW}Changing default shell to zsh...${RESET}"
  sudo usermod -s /usr/bin/zsh $USER
  echo -e "${GREEN}Default shell changed to zsh successfully!${RESET}"
else
  echo -e "${YELLOW}zsh is already the default shell, Skipping...${RESET}"
fi

echo -e "${CYAN}Start new zsh session? (y/n)${RESET}"
read -r response
if [[ $response =~ ^[Yy]$ ]]; then
  echo -e "${GREEN}Starting new zsh session...${RESET}"
  exec zsh -l
fi
