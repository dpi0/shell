#!/usr/bin/env bash

# enables automatic exit from a script when a command fails
set -e

if [[ "$1" == "chroot" ]]; then
  INSIDE_CHROOT=true
else
  INSIDE_CHROOT=false
fi

export DISK="/dev/vda"
export HOSTNAME="arch0"
export LOCALE_LANG_COMPLETE="en_US.UTF-8 UTF-8"
export LOCALE_LANG="en_US.UTF-8"
export TIMEZONE="Asia/Kolkata"
export KEYMAP="us"
export FONT="ter-132n"
export USERNAME="user"
export USERGROUP="wheel"
export USER_PASSWORD="user"
# export ROOT_PASSWORD="root"

# Color definitions
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
RESET='\033[0m'

# check if running as root
check_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as root${RESET}" 1>&2
    exit 1
  fi
}

# check UEFI platform
check_uefi() {
  if [ ! -d /sys/firmware/efi ]; then
    echo -e "${YELLOW}Warning: This script is intended for UEFI platforms${RESET}" 1>&2
    exit 1
  fi
}

# set preliminary setup
setup_preliminary() {
  echo -e "${GREEN}>>> Preliminary setup${RESET}"
  setfont "$FONT"
  loadkeys "$KEYMAP"
  timedatectl set-timezone "$TIMEZONE"
  timedatectl set-ntp true
  echo -e "${GREEN}Preliminary done!${RESET}"
}

# create partitions
create_partitions() {
  echo -e "${CYAN}>>> Creating Partitions${RESET}"
  parted -s "$DISK" mklabel gpt
  parted -s "$DISK" mkpart primary fat32 1MiB 256MiB
  parted -s "$DISK" set 1 esp on
  parted -s "$DISK" mkpart primary ext4 256MiB 1024MiB
  parted -s "$DISK" set 2 bls_boot on
  parted -s "$DISK" mkpart primary ext4 1024MiB 100%
  echo -e "${GREEN}Partition created${RESET}"
}

# format partitions
format_partitions() {
  echo -e "${CYAN}>>> Formatting Partitions${RESET}"
  mkfs.fat -F32 "$DISK"1
  mkfs.fat -F32 "$DISK"2
  mkfs.ext4 "$DISK"3
  echo -e "${GREEN}Partitions formatted${RESET}"
}

mount_partitions() {
  echo -e "${CYAN}>>> Mounting Partitions${RESET}"
  mount "$DISK"3 /mnt
  mkdir /mnt/efi /mnt/boot
  mount "$DISK"1 /mnt/efi
  mount "$DISK"2 /mnt/boot
  echo -e "${GREEN}Partitions mounted${RESET}"
}

pacstrap_install() {
  echo -e "${CYAN}>>> Pacstrap${RESET}"
  pacstrap /mnt base linux vim sudo less intel-ucode
  echo -e "${GREEN}Packages installed!${RESET}"
}

fstab() {
  echo -e "${GREEN}>>> Fstab${RESET}"
  genfstab -U /mnt >> /mnt/etc/fstab
  echo -e "${GREEN}Fstab done!${RESET}"
}

timezone() {
  echo -e "${CYAN}>>> Seting timezone${RESET}"
  ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
  hwclock -w
  echo -e "${GREEN}Timezone set successfully!${RESET}"
}

set_locale() {
  echo -e "${CYAN}>>> Setting locale...${RESET}"
  echo "$LOCALE_LANG_COMPLETE" >> /etc/locale.gen
  locale-gen
  echo "LANG=$LOCALE_LANG" >> /etc/locale.conf
  echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf
  echo "FONT=$FONT" >> /etc/vconsole.conf
  echo "$HOSTNAME" >> /etc/hostname
  echo -e "${GREEN}Locale set successfully!${RESET}"
}

create_user() {
  echo -e "${CYAN}>>> Creating user $USERNAME...${RESET}"
  useradd -mg "$USERGROUP" "$USERNAME"
  echo "$USERNAME:$USER_PASSWORD" | chpasswd
  echo "%$USERGROUP ALL=(ALL:ALL) ALL" >> /etc/sudoers
  echo -e "${GREEN}User $USERNAME created!${RESET}"
}

pacman_fix() {
  echo -e "${CYAN}>>> Configuring Pacman...${RESET}"
  sed -i 's/^#Color/Color/' /etc/pacman.conf
  sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
  sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
  echo -e "${GREEN}Pacman configured successfully!${RESET}"
}

more_packages() {
  echo -e "${CYAN}>>> Installing additional packages...${RESET}"
  pacman -S --noconfirm git openssh pacman-contrib networkmanager
  echo -e "${GREEN}Additional packages installed successfully!${RESET}"
}

systemd_services() {
  echo -e "${CYAN}>>> Enabling systemd services...${RESET}"
  systemctl enable fstrim.timer paccache.timer NetworkManager sshd
  echo -e "${GREEN}Systemd services enabled successfully!${RESET}"
}

bootloader_setup() {
  echo -e "${CYAN}>>> Installing bootloader...${RESET}"
  bootctl --esp-path=/efi --boot-path=/boot install
  
  echo -e "${CYAN}>>> Configuring bootloader settings...${RESET}"
  {
    echo timeout 0
    echo default arch.conf
    echo console-mode max
    echo editor no
  } >>/efi/loader/loader.conf
  
  echo -e "${CYAN}>>> Getting UUID for root partition...${RESET}"
  UUID=$(blkid -s UUID -o value "$DISK"3)

  echo -e "${CYAN}>>> Configuring bootloader entry for Arch Linux...${RESET}"
  {
    echo title Arch Linux
    echo linux /vmlinuz-linux
    echo initrd /initramfs-linux.img
    echo options root=UUID="$UUID" rw
  } >>/boot/loader/entries/arch.conf
  
  echo -e "${GREEN}>>> Bootloader installed and configured successfully!${RESET}"
}

base_chroot() {
  timezone
  set_locale
  create_user
  pacman_fix
  more_packages
  systemd_services
  bootloader_setup
}

base() {
  check_root
  check_uefi
  setup_preliminary
  create_partitions
  format_partitions
  mount_partitions
  pacstrap_install
  fstab

  cp "$0" /mnt/root/install.sh
  arch-chroot /mnt /bin/bash /root/install.sh chroot

  echo -e "${GREEN}Base system setup complete!${RESET}"

  echo -e "${GREEN}>>> Leaving chroot and rebooting"
  # exit

  umount -R /mnt
  reboot
}

main() {
  if [[ "$INSIDE_CHROOT" == true ]]; then
    base_chroot
  else
    read -r -p "Arch Install Script, proceed? (y/n)" choice
    case "$choice" in
      y | Y) base ;;
      n | N) exit ;;
      *) exit ;;
    esac
  fi
}

main; exit
