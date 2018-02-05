#!/bin/bash

# sync packages
sudo pacman -Syy

# full system upgrade
sudo pacman -Su

# fix network-manager-applet not asking for wifi pwd
sudo pacman -S --noconfirm --needed gnome-keyring

# essentials
sudo pacman -S --noconfirm --needed rsync git subversion cvd mercurial unzip unrar wget curl base-devel 

# install yaourt
cd /tmp/
git clone https://aur.archlinux.org/package-query.git
cd package-query && makepkg -si && cd -

cd /tmp/
git clone https://aur.archlinux.org/yaourt.git
cd yaourt && makepkg -si
cd -

# system tools
yaourt -S --noconfirm --needed vtop

# internet
sudo pacman -S --noconfirm --needed firefox firefox-i18n-de
sudopacman -S --noconfirm --needed thunderbird thunderbird-i18n-de
sudo pacman -S --noconfirm --needed chromium google-chrome google-talkplugin
yaourt -S --noconfirm --needed skypeforlinux-bin
sudo pacman -S --noconfirm --needed transmission-gtk
sudo pacman -S --noconfirm --needed filezilla
yaourt -S --noconfirm --needed slack-desktop
yaourt -S --noconfirm --needed zoom

# devel
yaourt -Sy visual-studio-code-bin
gpg --recv-keys --keyserver hkp://18.9.60.141 5CC908FDB71E12C2
yaourt -S --noconfirm --needed gitkraken
yaourt -S --noconfirm --needed robo3t-bin
yaourt -S --noconfirm --needed dbeaver
yaourt -S --noconfirm --needed postman-bin
sudo pacman -S --noconfirm --needed sqlite sqlitebrowser
sudo pacman -S --noconfirm --needed mysql-workbench

# lang
sudo pacman -S --noconfirm --needed nodejs npm
sudo pacman -S --noconfirm --needed jdk8-openjdk openjdk8-doc
sudo pacman -S --noconfirm --needed apache-ant
sudo pacman -S --noconfirm --needed maven
sudo pacman -S --noconfirm --needed php php-composer php-gd

# docker
sudo pacman -S --noconfirm --needed docker docker-compose
sudo gpasswd -a $USER docker

# graphics
sudo pacman -S --noconfirm --needed gimp gimp-help-de
yaourt -S --noconfirm --needed gimp-plugin-saveforweb
sudo pacman -S --noconfirm --needed shutter

# notes
yaourt -S --noconfirm --needed simplenote-electron-bin

# media
yaourt -S --noconfirm --needed spotify

# tools
yaourt -S --noconfirm --needed etcher etcher-cli

# arduino, embedded et al.
yaourt -S --noconfirm --needed arduino
sudo gpasswd -a $USER lock
sudo gpasswd -a $USER uucp
yaourt -S --noconfirm --needed fritzing
