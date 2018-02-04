#Potential variables: timezone, lang and local

passwd

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

hwclock --systohc --utc

echo "en_DK.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_DK.ISO-8859-1 ISO-8859-1" >> /etc/locale.gen
locale-gen

pacman --noconfirm --needed -S networkmanager intel-ucode dosfstools efibootmgr
systemctl enable NetworkManager
systemctl start NetworkManager

echo "initramfs creation..."
sleep 5
file=/etc/mkinitcpio.conf
search="^\s*HOOKS=.*$"
replace="HOOKS=\\\"base udev autodetect modconf block keymap encrypt lvm2 filesystems keyboard shutdown fsck usr\\\""
grep -q "$search" "$file" && sed -i "s#$search#$replace#" "$file" || echo "$replace" >> "$file"
mkinitcpio -p linux

echo "installing bootctl..."
sleep 5
bootctl --path=/boot install
> /boot/loader/loader.conf
echo "default arch" >> /boot/loader/loader.conf
echo "timeout 5" >> /boot/loader/loader.conf
LUKS_UUID="$(cryptsetup luksUUID $(cat idevice))"
touch /boot/loader/entries/arch.conf
echo "title Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options quiet cryptdevice=UUID=$LUKS_UUID:arch:allow-discards root=/dev/mapper/arch-root rw" >> /boot/loader/entries/arch.conf
echo "arch UUID=$LUKS_UUID none luks,discard" > /etc/crypttab

pacman --noconfirm --needed -S dialog
larbs() { curl -LO http://larbs.xyz/larbs.sh && bash larbs.sh ;}
dialog --title "Install Luke's Rice" --yesno "This install script will easily let you access Luke's Auto-Rice Boostrapping Scripts (LARBS) which automatically install a full Arch Linux i3-gaps desktop environment.\n\nIf you'd like to install this, select yes, otherwise select no.\n\nLuke"  15 60 && larbs
