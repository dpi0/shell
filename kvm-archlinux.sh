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
  echo ">>> Preliminary setup: font, keyboard, time, date and package mirrors..."
  setfont "$FONT"
  loadkeys "$KEYMAP"
  timedatectl set-timezone "$TIMEZONE"
  timedatectl set-ntp true
  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  reflector --verbose -c India -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
  echo "Preliminary done!"
}

create_partitions() {
  echo ">>> Creating Partitions: /efi and /root..."
  parted -s "$DISK" mklabel gpt
  parted -s "$DISK" mkpart primary fat32 1MiB 512MiB
  parted -s "$DISK" set 1 esp on
  parted -s "$DISK" mkpart primary ext4 512MiB 100%
  echo "Partitions created!"
}

format_partitions() {
  echo ">>> Formatting Partitions..."
  mkfs.fat -F32 "$DISK"1
  mkfs.ext4 "$DISK"2
  echo "Partitions formatted!"
}

mount_partitions() {
  echo ">>> Mounting Partitions..."
  mount "$DISK"2 /mnt
  mount --mkdir "$DISK"1 /mnt/boot
  echo "Partitions mounted!"
}

pacstrap_install() {
  echo ">>> Pacstrap"
  pacstrap /mnt base linux-lts vim sudo less intel-ucode
  echo "Packages installed!"
}

fstab() {
  echo ">>> Writing fstab..."
  genfstab -U /mnt >> /mnt/etc/fstab
  echo "fstab written!"
}

timezone() {
  echo ">>> Setting timezone..."
  ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
  hwclock -w
  echo "Timezone set!"
}

set_locale() {
  echo ">>> Setting locale..."
  echo "$LOCALE_LANG_COMPLETE" >> /etc/locale.gen
  locale-gen
  echo "LANG=$LOCALE_LANG" >> /etc/locale.conf
  echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf
  echo "FONT=$FONT" >> /etc/vconsole.conf
  echo "$HOSTNAME" >> /etc/hostname
  echo "Locale set!"
}

create_user() {
  echo ">>> Creating user $USERNAME..."
  useradd -mg "$USERGROUP" "$USERNAME"
  echo "$USERNAME:$USER_PASSWORD" | chpasswd
  echo "%$USERGROUP ALL=(ALL:ALL) ALL" >> /etc/sudoers
  echo "User $USERNAME created!"
}

pacman_fix() {
  echo ">>> Configuring Pacman..."
  sed -i 's/^#Color/Color/' /etc/pacman.conf
  sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
  sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
  echo "Pacman configured!"
}

more_packages() {
  echo ">>> Installing additional packages..."
  pacman -S --noconfirm git openssh pacman-contrib networkmanager
  echo "Additional packages installed!"
}

systemd_services() {
  echo ">>> Enabling systemd services..."
  systemctl enable fstrim.timer paccache.timer NetworkManager sshd
  echo "Systemd services enabled!"
}

bootloader_setup() {
  echo ">>> Installing bootloader..."
  bootctl --path=/boot install
  
  echo ">>> Configuring bootloader settings..."
  {
    echo default arch
    echo timeout 0
    echo console-mode max
    echo editor no
  } >>/boot/loader/loader.conf
  
  echo ">>> Getting UUID for root partition..."
  UUID=$(blkid -s UUID -o value "$DISK"2)

  echo ">>> Configuring bootloader entry for Arch Linux..."
  {
    echo title Arch Linux
    echo linux /vmlinuz-linux
    echo initrd /initramfs-linux.img
    echo options root=UUID="$UUID" quiet rw
  } >>/boot/loader/entries/arch.conf
  
  echo ">>> Bootloader installed and configured!"
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

  echo "Base system setup complete!"

  echo ">>> Leaving chroot and rebooting"
  
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

main; exit
