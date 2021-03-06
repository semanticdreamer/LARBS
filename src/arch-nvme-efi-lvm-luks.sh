#!/bin/bash

INSTALL_DEVICE="/dev/nvme0n1"
echo "${INSTALL_DEVICE}" > idevice

#This is a lazy script I have for auto-installing Arch Linux with full 
#Luks LVM2 Disk Encryption and systemd-boot (a.k.a gummiboot) for EFI Loader.
#DO NOT RUN THIS YOURSELF because Step 1 is it reformatting ${INSTALL_DEVICE} WITHOUT confirmation,
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

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire ${INSTALL_DEVICE} drive.\n\nThis script is only really for me so I can autoinstall Arch.\n\n Matthias"  15 60 || exit

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "Do you think I'm meming? Only select yes to DELET your entire ${INSTALL_DEVICE} and reinstall Arch.\n\nTo stop this script, press no."  10 60 || exit

dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

dialog --no-cancel --inputbox "Enter partitionsize in gb, separated by space for root and swap; 100% of free will become home." 10 60 2>psize

IFS=' ' read -ra SIZE <<< $(cat psize)

re='^[0-9]+$'
if ! [ ${#SIZE[@]} -eq 2 ] || ! [[ ${SIZE[0]} =~ $re ]] || ! [[ ${SIZE[1]} =~ $re ]] ; then
    SIZE=(30 1);
fi

timedatectl set-ntp true

echo "partitioning drive..."
sleep 5
sgdisk -og ${INSTALL_DEVICE}
sgdisk -n 1:2048:+512MiB -t 1:ef00 ${INSTALL_DEVICE}
start_of=`sgdisk -f ${INSTALL_DEVICE}`
end_of=`sgdisk -E ${INSTALL_DEVICE}`
sgdisk -n "2:$start_of:$end_of" -t 2:8e00 ${INSTALL_DEVICE}
sgdisk -p ${INSTALL_DEVICE}

echo "cryptsetup (luks) and lvm..."
sleep 5
cryptsetup -c aes-xts-plain64 -h sha512 -s 512 --use-random luksFormat ${INSTALL_DEVICE}p2
cryptsetup --allow-discards luksOpen ${INSTALL_DEVICE}p2 "$(cat comp)-opsecftw"
pvcreate "/dev/mapper/$(cat comp)-opsecftw"
vgcreate arch "/dev/mapper/$(cat comp)-opsecftw"
lvcreate -L ${SIZE[0]}GB arch -n root
lvcreate -L ${SIZE[1]}GB arch -n swap
lvcreate -l 100%FREE arch -n home

echo "activating lvm..."
sleep 5
modprobe dm_mod
vgscan
vgchange -ay

echo "formatting partitions..."
sleep 5
mkfs.fat -F32 ${INSTALL_DEVICE}p1
mkfs.ext4 /dev/arch/root
mkfs.ext4 /dev/arch/home
mkswap /dev/arch/swap
swapon --discard /dev/arch/swap

echo "mounting drives..."
sleep 5
mount -o discard /dev/arch/root /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount -o discard ${INSTALL_DEVICE}p1 /mnt/boot
mount -o discard /dev/arch/home /mnt/home

echo "ranking mirrors..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

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

curl https://raw.githubusercontent.com/semanticdreamer/LARBS/master/src/chroot-nvme-efi-lvm-luks.sh > /mnt/chroot.sh && cp idevice /mnt/idevice && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh && rm /mnt/idevice

cat comp > /mnt/etc/hostname && rm comp

dialog --defaultno --title "Final Qs" --yesno "Eject CD/ROM (if any)?"  5 30 && eject
dialog --defaultno --title "Final Qs" --yesno "Reboot computer?"  5 30 && reboot
dialog --defaultno --title "Final Qs" --yesno "Return to chroot environment?"  6 30 && arch-chroot /mnt
clear
