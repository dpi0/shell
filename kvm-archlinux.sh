#!/usr/bin/env bash

# Enables automatic exit from a script when a command fails
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

# Helper function to print messages
print_() {
  echo ">>> $1"
}

# Helper function to run commands with error handling
run_() {
  print_ "Running: $1"
  eval "$1" || { echo "Error: Command failed"; exit 1; }
}

check_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
  fi
}

check_uefi() {
  if [ ! -d /sys/firmware/efi ]; then
    echo "Warning: This script is intended for UEFI platforms" 1>&2
    exit 1
  fi
}

setup_preliminary() {
  print_ "Preliminary setup..."
  run_ "setfont $FONT"
  run_ "loadkeys $KEYMAP"
  run_ "timedatectl set-timezone $TIMEZONE"
  run_ "timedatectl set-ntp true"
  run_ "cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak"
  run_ "reflector --verbose -c India -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist"
  print_ "Preliminary setup done!"
}

create_partitions() {
  print_ "Creating partitions..."
  run_ "parted -s $DISK mklabel gpt"
  run_ "parted -s $DISK mkpart primary fat32 1MiB 256MiB"
  run_ "parted -s $DISK set 1 esp on"
  run_ "parted -s $DISK mkpart primary ext4 256MiB 1024MiB"
  run_ "parted -s $DISK set 2 bls_boot on"
  run_ "parted -s $DISK mkpart primary ext4 1024MiB 100%"
  print_ "Partitions created!"
}

format_partitions() {
  print_ "Formatting partitions..."
  run_ "mkfs.fat -F32 ${DISK}1"
  run_ "mkfs.fat -F32 ${DISK}2"
  run_ "mkfs.ext4 ${DISK}3"
  print_ "Partitions formatted!"
}

mount_partitions() {
  print_ "Mounting partitions..."
  run_ "mount ${DISK}3 /mnt"
  run_ "mkdir /mnt/efi /mnt/boot"
  run_ "mount ${DISK}1 /mnt/efi"
  run_ "mount ${DISK}2 /mnt/boot"
  print_ "Partitions mounted!"
}

pacstrap_install() {
  print_ "Installing base system..."
  run_ "pacstrap /mnt base linux vim sudo less intel-ucode"
  print_ "Base system installed!"
}

fstab() {
  print_ "Generating fstab..."
  run_ "genfstab -U /mnt >> /mnt/etc/fstab"
  print_ "fstab generated!"
}

timezone() {
  print_ "Setting timezone..."
  run_ "ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime"
  run_ "hwclock -w"
  print_ "Timezone set!"
}

set_locale() {
  print_ "Setting locale..."
  run_ "echo $LOCALE_LANG_COMPLETE >> /etc/locale.gen"
  run_ "locale-gen"
  run_ "echo LANG=$LOCALE_LANG >> /etc/locale.conf"
  run_ "echo KEYMAP=$KEYMAP >> /etc/vconsole.conf"
  run_ "echo FONT=$FONT >> /etc/vconsole.conf"
  run_ "echo $HOSTNAME >> /etc/hostname"
  print_ "Locale set!"
}

create_user() {
  print_ "Creating user $USERNAME..."
  run_ "useradd -mg $USERGROUP $USERNAME"
  run_ "echo $USERNAME:$USER_PASSWORD | chpasswd"
  run_ "echo %$USERGROUP ALL=(ALL:ALL) ALL >> /etc/sudoers"
  print_ "User $USERNAME created!"
}

pacman_fix() {
  print_ "Configuring Pacman..."
  run_ "sed -i 's/^#Color/Color/' /etc/pacman.conf"
  run_ "sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf"
  run_ "sed -i '/^Color/a ILoveCandy' /etc/pacman.conf"
  print_ "Pacman configured!"
}

more_packages() {
  print_ "Installing additional packages..."
  run_ "pacman -S --noconfirm git openssh pacman-contrib networkmanager"
  print_ "Additional packages installed!"
}

systemd_services() {
  print_ "Enabling systemd services..."
  run_ "systemctl enable fstrim.timer paccache.timer NetworkManager sshd"
  print_ "Systemd services enabled!"
}

bootloader_setup() {
  print_ "Installing bootloader..."
  run_ "bootctl --esp-path=/efi --boot-path=/boot install"
  
  print_ "Configuring bootloader settings..."
  run_ "echo timeout 0 >> /efi/loader/loader.conf"
  run_ "echo default arch.conf >> /efi/loader/loader.conf"
  run_ "echo console-mode max >> /efi/loader/loader.conf"
  run_ "echo editor no >> /efi/loader/loader.conf"
  
  print_ "Getting UUID for root partition..."
  UUID=$(blkid -s UUID -o value ${DISK}3)

  print_ "Configuring bootloader entry for Arch Linux..."
  run_ "echo title Arch Linux >> /boot/loader/entries/arch.conf"
  run_ "echo linux /vmlinuz-linux >> /boot/loader/entries/arch.conf"
  run_ "echo initrd /initramfs-linux.img >> /boot/loader/entries/arch.conf"
  run_ "echo options root=UUID=$UUID rw >> /boot/loader/entries/arch.conf"
  
  print_ "Bootloader installed and configured!"
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

  print_ "Base system setup complete!"

  print_ "Leaving chroot and rebooting..."
  
  umount -R /mnt
  reboot
}

main() {
  if [[ "$INSIDE_CHROOT" == true ]]; then
    base_chroot
  else
    base
  fi
}

main
exit
