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
    echo "Unable to identify system. Please install Zsh manually."
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
            sudo pacman -Syu "$1"
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

if [ "$OS" == "Ubuntu" ]; then
  echo -e "${YELLOW}Ubuntu system detected. Remove Snap? (y/n)${RESET}"
  read -r response
  if [[ $response =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Removing Snap from Ubuntu system...${RESET}"
    sudo snap list
    # Remove all Snap packages
    echo -e "${RED}Removing Snap packages...${RESET}"
    sudo snap remove --purge $(snap list | cut -d' ' -f1)
    # Remove Snapd
    echo -e "${RED}Removing Snapd...${RESET}"
    sudo apt remove --purge snapd -y
    # Remove Snap directories
    echo -e "${RED}Removing Snap directories...${RESET}"
    sudo rm -rf ~/snap
    sudo rm -rf /snap
    sudo rm -rf /var/snap
    sudo rm -rf /var/lib/snapd
    echo -e "${GREEN}Snap removed successfully!${RESET}"
  else
    echo -e "${YELLOW}Skipping Snap removal...${RESET}"
  fi
else
  echo -e "${YELLOW}Not an Ubuntu system, skipping Snap removal...${RESET}"
fi

# Install Aops
packages_apt=(zsh tmux git gpg btop eza fzf gdu zip unzip)
packages_pacman=(zsh tmux git gpg btop eza fzf fd gdu nvim zip unzip)

if [ "$OS" == "Ubuntu" ]; then
    for package in "${packages_apt[@]}"; do
        install_package "$package"
    done
    
    # Check for fdfind or fd
    if ! command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        install_package "fd-find"
    fi

    # Check for nvim
    if ! command -v nvim &> /dev/null; then
        install_package "neovim"
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

echo -e "${GREEN}Utilities installed!${RESET}"

echo
# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo -e "${YELLOW}docker is already installed. Skipping...${RESET}"
else
    # Ask for confirmation before installing Docker
    read -p "Install Docker? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$OS" == "Ubuntu" ]; then
            echo -e "${GREEN}Installing Docker...${RESET}"
            sudo apt-get update
            sudo apt-get install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            echo -e "${GREEN}docker installation completed!${RESET}"
        elif [ "$OS" == "Arch Linux" ]; then
            echo -e "${GREEN}Installing Docker...${RESET}"
            sudo pacman -Syu docker docker-compose
            echo -e "${GREEN}docker installation completed!${RESET}"
        fi
    else
        echo -e "${RED}docker installation cancelled.${RESET}"
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

if [ "$SHELL" != "/sbin/zsh" ] && [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/sbin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo -e "${YELLOW}Changing default shell to zsh...${RESET}"
  sudo chsh -s /usr/bin/zsh $USER
  echo -e "${GREEN}Default shell changed to zsh successfully!${RESET}"
else
  echo -e "${YELLOW}zsh is already the default shell, Skipping...${RESET}"
fi

echo -e "${CYAN}Start new zsh session? (y/n)${RESET}"
read -r response
if [[ $response =~ ^[Yy]$ ]]; then
  echo -e "${GREEN}Starting new zsh session...${RESET}"
  exec zsh
fi
