#!/bin/bash

# sync packages
sudo pacman -Syy

# full system upgrade
sudo pacman -Su

# fix network-manager-applet not asking for wifi pwd
sudo pacman -S gnome-keyring

# essentials
sudo pacman -S rsync git subversion cvd mercurial unzip unrar wget curl base-devel 

# install yaourt
cd /tmp/
git clone https://aur.archlinux.org/package-query.git
cd package-query && makepkg -si && cd -

cd /tmp/
git clone https://aur.archlinux.org/yaourt.git
cd yaourt && makepkg -si
cd -

# system tools
yaourt -S vtop

# internet
sudo pacman -S firefox firefox-i18n-de
sudo pacman -S thunderbird thunderbird-i18n-de
sudo pacman -S chromium google-chrome google-talkplugin
yaourt -S skypeforlinux-bin
sudo pacman -S transmission-gtk
sudo pacman -S filezilla
yaourt -S slack-desktop
yaourt -S zoom

# devel
yaourt -Sy visual-studio-code-bin
gpg --recv-keys --keyserver hkp://18.9.60.141 5CC908FDB71E12C2
yaourt -S gitkraken
yaourt -S robo3t-bin
yaourt -S dbeaver
yaourt -S postman-bin
sudo pacman -S sqlite sqlitebrowser
sudo pacman -S mysql-workbench

# lang
sudo pacman -S nodejs npm
sudo pacman -S jdk8-openjdk openjdk8-doc
sudo pacman -S apache-ant
sudo pacman -S maven
sudo pacman -S php php-composer php-gd

# docker
sudo pacman -S docker docker-compose
sudo gpasswd -a $USER docker

# graphics
sudo pacman -S gimp gimp-help-de
yaourt -S gimp-plugin-saveforweb
sudo pacman -S shutter

# notes
yaourt -S simplenote-electron-bin

# media
yaourt -S spotify

# tools
yaourt -S etcher etcher-cli

# arduino, embedded et al.
yaourt -S arduino
sudo gpasswd -a $USER lock
sudo gpasswd -a $USER uucp
yaourt -S fritzing
