#!/bin/bash

# download fresh package databases
sudo pacman -Syy

# full system upgrade
sudo pacman -Su

# fix network-manager-applet not asking for wifi pwd
sudo pacman -S --noconfirm --needed gnome-keyring

# intel video
sudo pacman -S --noconfirm --needed xf86-video-intel

# power
sudo pacman -S --noconfirm --needed acpi_call powertop x86_energy_perf_policy

# bluetooth
sudo pacman -S --noconfirm --needed bluez bluez-utils blueman
sudo systemctl enable bluetooth.service

# essentials
sudo pacman -S --noconfirm --needed openssh rsync git subversion cvs mercurial unzip unrar wget curl base-devel 

# install yaourt
if pacman -Qs package-query > /dev/null ; then
  echo "yaourt is already installed"
else
  cd /tmp/
  git clone https://aur.archlinux.org/package-query.git
  cd package-query && makepkg -si && cd -
fi

if pacman -Qs yaourt > /dev/null ; then
  echo "package-query is already installed"
else
    cd /tmp/
    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt && makepkg -si && cd -
fi

# essential system tools
yaourt -S --noconfirm --needed vtop dnsutils

# internet
sudo pacman -S --noconfirm --needed firefox firefox-i18n-de firefox-developer-edition
sudo pacman -S --noconfirm --needed thunderbird thunderbird-i18n-de
yaourt -S --noconfirm --needed google-chrome google-talkplugin
sudo pacman -S --noconfirm --needed chromium
yaourt -S --noconfirm --needed skypeforlinux-preview-bin
sudo pacman -S --noconfirm --needed transmission-gtk
sudo pacman -S --noconfirm --needed filezilla
yaourt -S --noconfirm --needed slack-desktop
yaourt -S --noconfirm --needed zoom
yaourt -S --noconfirm --needed keybase-bin

# devel
yaourt -S --noconfirm --needed visual-studio-code-bin
gpg --recv-keys --keyserver hkp://18.9.60.141 5CC908FDB71E12C2
yaourt -S --noconfirm --needed gitkraken
yaourt -S --noconfirm --needed robo3t-bin
yaourt -S --noconfirm --needed dbeaver
yaourt -S --noconfirm --needed postman-bin
sudo pacman -S --noconfirm --needed sqlite sqlitebrowser
sudo pacman -S --noconfirm --needed mysql-workbench
yaourt -S --noconfirm --needed rstudio-desktop-bin

# lang
sudo pacman -S --noconfirm --needed nodejs npm
sudo pacman -S --noconfirm --needed go go-tools
sudo pacman -S --noconfirm --needed jdk8-openjdk openjdk8-doc
sudo pacman -S --noconfirm --needed apache-ant
sudo pacman -S --noconfirm --needed maven
sudo pacman -S --noconfirm --needed php php-composer php-gd
sudo pacman -S --noconfirm --needed python-pip

# cloud
yaourt -S --noconfirm --needed scaleway-cli
yaourt -S --noconfirm --needed aws-cli-git

# docker
sudo pacman -S --noconfirm --needed docker docker-compose
sudo gpasswd -a $USER docker
sudo systemctl enable docker
sudo systemctl start docker

# graphics
sudo pacman -S --noconfirm --needed gimp gimp-help-de
yaourt -S --noconfirm --needed gimp-plugin-saveforweb
yaourt -S --noconfirm --needed shutter

# writing
yaourt -S --noconfirm --needed simplenote-electron-bin
yaourt -S --noconfirm --needed plantuml

# media
yaourt -S --noconfirm --needed spotify

# nitrokey —— currently broken, because  dep on git repo
#sudo pacman -S --noconfirm --needed  ccid
#yaourt -S --noconfirm --needed nitrokey-app

# arduino, embedded et al.
yaourt -S --noconfirm --needed arduino
sudo gpasswd -a $USER lock
sudo gpasswd -a $USER uucp
yaourt -S --noconfirm --needed fritzing

# tools
sudo npm install -g etcher-cli

# printer
sudo pacman -S --noconfirm --needed cups 
sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service
sudo pacman -S --noconfirm --needed hplip
sudo pacman -S --noconfirm --needed system-config-printer
