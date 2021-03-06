#Potential variables: timezone, lang and local

passwd

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

hwclock --systohc

echo "en_DK.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_DK.UTF-8" > /etc/locale.conf
localectl set-keymap de-latin1-nodeadkeys
localectl set-x11-keymap de-latin1-nodeadkeys

pacman --noconfirm --needed -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

pacman --noconfirm --needed -S grub && grub-install --target=i386-pc "$(cat idevice)" && grub-mkconfig -o /boot/grub/grub.cfg

pacman --noconfirm --needed -S dialog
larbs() { curl -LO http://larbs.xyz/larbs.sh && bash larbs.sh ;}
dialog --title "Install Luke's Rice" --yesno "This install script will easily let you access Luke's Auto-Rice Boostrapping Scripts (LARBS) which automatically install a full Arch Linux i3-gaps desktop environment.\n\nIf you'd like to install this, select yes, otherwise select no.\n\nLuke"  15 60 && larbs
