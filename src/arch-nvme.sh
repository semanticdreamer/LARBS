#!/bin/bash

INSTALL_DEVICE="/dev/nvme0n1"
echo "${INSTALL_DEVICE}" > idevice

#This is a lazy script I have for auto-installing Arch.
#It's not officially part of LARBS, but I use it for testing.
#DO NOT RUN THIS YOURSELF because Step 1 is it reformatting ${INSTALL_DEVICE} WITHOUT confirmation,
#which means RIP in peace qq your data unless you've already backed up all of your drive.

pacman -S --noconfirm dialog || (echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?" && exit)
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire ${INSTALL_DEVICE} drive.\n\nThis script is only really for me so I can autoinstall Arch.\n\n Matthias"  15 60 || exit

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "Do you think I'm meming? Only select yes to DELETE your entire ${INSTALL_DEVICE} and reinstall Arch.\n\nTo stop this script, press no."  10 60 || exit

dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

dialog --no-cancel --inputbox "Enter partitionsize in gb, separated by space (swap & root)." 10 60 2>psize

IFS=' ' read -ra SIZE <<< $(cat psize)

re='^[0-9]+$'
if ! [ ${#SIZE[@]} -eq 2 ] || ! [[ ${SIZE[0]} =~ $re ]] || ! [[ ${SIZE[1]} =~ $re ]] ; then
    SIZE=(12 25);
fi

timedatectl set-ntp true

cat <<EOF | fdisk ${INSTALL_DEVICE}
o
n
p


+200M
n
p


+${SIZE[0]}G
n
p


+${SIZE[1]}G
n
p


w
EOF
partprobe

mkfs.ext4 ${INSTALL_DEVICE}4
mkfs.ext4 ${INSTALL_DEVICE}3
mkfs.ext4 ${INSTALL_DEVICE}1
mkswap ${INSTALL_DEVICE}2
swapon ${INSTALL_DEVICE}2
mount ${INSTALL_DEVICE}3 /mnt
mkdir /mnt/boot
mount ${INSTALL_DEVICE}1 /mnt/boot
mkdir /mnt/home
mount ${INSTALL_DEVICE}4 /mnt/home

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

curl https://raw.githubusercontent.com/semanticdreamer/LARBS/master/src/chroot-nvme.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh

cat comp > /mnt/etc/hostname && rm comp

dialog --defaultno --title "Final Qs" --yesno "Eject CD/ROM (if any)?"  5 30 && eject
dialog --defaultno --title "Final Qs" --yesno "Reboot computer?"  5 30 && reboot
dialog --defaultno --title "Final Qs" --yesno "Return to chroot environment?"  6 30 && arch-chroot /mnt
clear
