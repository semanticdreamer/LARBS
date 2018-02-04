#!/bin/bash

#This is a lazy script I have for auto-installing Arch Linux with full 
#Luks LVM2 Disk Encryption and systemd-boot (a.k.a gummiboot) for EFI Loader.
#DO NOT RUN THIS YOURSELF because Step 1 is it reformatting /dev/nvme1n1 WITHOUT confirmation,
#which means RIP in peace qq your data unless you've already backed up all of your drive.

#Credits to, because pointers taken from:
#https://github.com/LukeSmithxyz/LARBS
#https://github.com/wrzlbrmft/arch-install
#https://github.com/goldsloam/archinstaller
#https://github.com/HardenedArray/Encrypted-Arch-UEFI-Installation
#http://www.saminiir.com/installing-arch-linux-on-dell-xps-15/
#https://gist.github.com/cblegare/746d37208c611f152137cb60cb14380f

#
# ** WARNING ** THIS IS WORK-IN-PROGRESS — CLEARLY !! NOT !! intended for any other use than my tinkering w/ an semi-automated Arch install
#

pacman -S --noconfirm dialog || (echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?" && exit)
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire /dev/nvme1n1 drive.\n\nThis script is only really for me so I can autoinstall Arch.\n\n Matthias"  15 60 || exit

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "Do you think I'm meming? Only select yes to DELET your entire /dev/nvme1n1 and reinstall Arch.\n\nTo stop this script, press no."  10 60 || exit

dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

timedatectl set-ntp true

echo "partitioning drive..."
sleep 5
sgdisk -og /dev/nvme1n1
sgdisk -n 1:2048:+512MiB -t 1:ef00 /dev/nvme1n1
start_of=`sgdisk -f /dev/nvme1n1`
end_of=`sgdisk -E /dev/nvme1n1`
sgdisk -n "2:$start_of:$end_of" -t 2:8e00 /dev/nvme1n1
sgdisk -p /dev/nvme1n1

echo "cryptsetup (luks) and lvm..."
sleep 5
cryptsetup luksFormat /dev/nvme1n1p2
cryptsetup --allow-discards luksOpen /dev/nvme1n1p2 "$(cat comp)-opsecftw"
pvcreate --dataalignment 1m "/dev/mapper/$(cat comp)-opsecftw"
vgcreate arch "/dev/mapper/$(cat comp)-opsecftw"
lvcreate -L 100GB arch -n root
lvcreate -L 16GB arch -n swap
lvcreate -l 100%FREE arch -n home

echo "activating lvm..."
sleep 5
modprobe dm_mod
vgscan
vgchange -ay

echo "formatting partitions..."
sleep 5
mkfs.fat -F32 /dev/nvme1n1p1
mkfs.ext4 /dev/arch/root
mkfs.ext4 /dev/arch/home
mkswap /dev/arch/swap
swapon --discard /dev/arch/swap

echo "mounting drives..."
sleep 5
mount -o discard /dev/arch/root /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount -o discard /dev/nvme1n1p1 /mnt/boot
mount -o discard /dev/arch/home /mnt/home

echo "ranking mirrors..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
rankmirrors -n 5 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

cat /mnt/etc/fstab | sed -e 's/\(data=ordered\)/\1,discard/' > /tmp/fstab
cat /tmp/fstab > /mnt/etc/fstab
rm /tmp/fstab

cat /mnt/etc/fstab | sed -e 's/\(swap\s*defaults\)/\1,discard/' > /tmp/fstab
cat /tmp/fstab > /mnt/etc/fstab
rm /tmp/fstab

cat /mnt/etc/fstab | sed -e 's/relatime/noatime/' > /tmp/fstab
cat /tmp/fstab > /mnt/etc/fstab
rm /tmp/fstab

curl https://raw.githubusercontent.com/semanticdreamer/LARBS/master/src/chroot-nvme1n1-efi-lvm-luks.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh

cat comp > /mnt/etc/hostname && rm comp

dialog --defaultno --title "Final Qs" --yesno "Eject CD/ROM (if any)?"  5 30 && eject
dialog --defaultno --title "Final Qs" --yesno "Reboot computer?"  5 30 && reboot
dialog --defaultno --title "Final Qs" --yesno "Return to chroot environment?"  6 30 && arch-chroot /mnt
clear
