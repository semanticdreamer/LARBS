#!/bin/bash

# sync packages
sudo pacman -Syy

# full system upgrade
sudo pacman -Su

# fix network-manager-applet not asking for wifi pwd
sudo pacman -S gnome-keyring

# essentials
sudo pacman -S rsync git unzip unrar wget curl base-devel 

# install yaourt
cd /tmp/
git clone https://aur.archlinux.org/package-query.git
cd package-query && makepkg -si && cd -

cd /tmp/
git clone https://aur.archlinux.org/yaourt.git
cd yaourt && makepkg -si
cd -

# system tools
yaourt -Sy vtop

# internet
sudo pacman -S firefox

# devel
yaourt -Sy visual-studio-code-bin

gpg --recv-keys --keyserver hkp://18.9.60.141 5CC908FDB71E12C2
yaourt -Sy gitkraken

# notes
yaourt -Sy simplenote-electron-bin
