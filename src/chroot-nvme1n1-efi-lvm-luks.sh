#Potential variables: timezone, lang and local

passwd

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

hwclock --systohc --utc

echo "en_DK.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_DK.ISO-8859-1 ISO-8859-1" >> /etc/locale.gen
locale-gen

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
rankmirrors -n 5 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

pacman --noconfirm --needed -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager


echo "initramfs creation..."
sleep 2
file=/mnt/archbox/etc/mkinitcpio.conf
search="^\s*HOOKS=.*$"
replace="HOOKS=\\\"base udev autodetect modconf block keymap encrypt lvm2 filesystems keyboard shutdown fsck usr\\\""
grep -q "$search" "$file" && sed -i "s#$search#$replace#" "$file" || echo "$replace" >> "$file"
mkinitcpio -p linux

echo "installing bootctl..."
bootctl --path=/boot install
> /boot/loader/loader.conf
echo "default arch" >> /boot/loader/loader.conf
echo "timeout 0" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf
datUUID=blkid | sed -n '/nvme1n1/s/.*UUID=\"\([^\"]*\)\".*/\1/p'
touch /boot/loader/entries/arch.conf
echo "title Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=$datUUID:arch:allow-discards root=/dev/mapper/arch-root quiet rw" >> /boot/loader/entries/arch.conf
echo "arch UUID=$datUUID none luks,discard" > /etc/crypttab

pacman --noconfirm --needed -S dialog
larbs() { curl -LO http://larbs.xyz/larbs.sh && bash larbs.sh ;}
dialog --title "Install Luke's Rice" --yesno "This install script will easily let you access Luke's Auto-Rice Boostrapping Scripts (LARBS) which automatically install a full Arch Linux i3-gaps desktop environment.\n\nIf you'd like to install this, select yes, otherwise select no.\n\nLuke"  15 60 && larbs
