#!/bin/bash

# download fresh package databases
sudo pacman -Syy

# full system upgrade
sudo pacman -Su

# Adaptec SAS 44300, 48300, 58300 Sequencer Firmware for AIC94xx driver
yaourt -S --noconfirm --needed aic94xx-firmware

# Driver for Western Digital WD7193, WD7197 and WD7296 SCSI cards
yaourt -S --noconfirm --needed wd719x-firmware

# fix network-manager-applet not asking for wifi pwd
sudo pacman -S --noconfirm --needed gnome-keyring

# Connect to IPsec VPNs, Cisco compatible
sudo pacman -S --noconfirm --needed networkmanager-vpnc

# networking, remote access
sudo pacman -S --noconfirm --needed freerdp rdesktop

# intel video, hardware video acceleration
sudo pacman -S --noconfirm --needed xf86-video-intel
sudo pacman -S --noconfirm --needed libva-intel-driver 

# power
sudo pacman -S --noconfirm --needed acpi_call powertop x86_energy_perf_policy

# bluetooth
sudo pacman -S --noconfirm --needed bluez bluez-utils blueman
sudo systemctl enable bluetooth.service

# backlight
yaourt -S --noconfirm --needed acpilight

# essentials
sudo pacman -S --noconfirm --needed openssh rsync git subversion cvs mercurial unzip unrar wget curl base-devel cdrkit xsel autofs

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
sudo pacman -S --noconfirm --needed hugo
yaourt -S --noconfirm --needed crossftp-client

# devel
yaourt -S --noconfirm --needed visual-studio-code-bin
gpg --recv-keys --keyserver hkp://18.9.60.141 5CC908FDB71E12C2
yaourt -S --noconfirm --needed gitkraken
yaourt -S --noconfirm --needed git-lfs
yaourt -S --noconfirm --needed robo3t-bin
yaourt -S --noconfirm --needed dbeaver
yaourt -S --noconfirm --needed postman-bin
sudo pacman -S --noconfirm --needed sqlite sqlitebrowser
yaourt -S --noconfirm --needed git-town

# SQLite's REGEXP calls a user defined function
# http://www.sqlite.org/lang_expr.html
# pcre = Perl regular expressions in a loadable module
yaourt -S --noconfirm --needed sqlite-pcre-git
if [ ! -f /home/matthias/.sqliterc ]; then
  echo ".load /usr/lib/sqlite3/pcre.so" > /home/matthias/.sqliterc
fi

sudo pacman -S --noconfirm --needed mysql-workbench
yaourt -S --noconfirm --needed rstudio-desktop-bin
if [ ! -d ~/Code/plantumlqeditor ]; then
  mkdir -p ~/Code
  cd ~/Code
  git clone https://github.com/borco/plantumlqeditor.git
  cd -
fi
cd ~/Code/plantumlqeditor && cmake && make
ln -sf ~/Code/plantumlqeditor/plantumlqeditor ~/.config/Scripts/

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

# graphics, photos
sudo pacman -S --noconfirm --needed gimp gimp-help-de
yaourt -S --noconfirm --needed gimp-plugin-saveforweb
yaourt -S --noconfirm --needed shutter
yaourt -S --noconfirm --needed gifski
sudo pacman -S --noconfirm --needed shotwell

# video
sudo pacman -S --noconfirm --needed vlc

# writing
yaourt -S --noconfirm --needed simplenote-electron-bin
yaourt -S --noconfirm --needed plantuml

# media
yaourt -S --noconfirm --needed spotify

# pdf
yaourt -S --noconfirm --needed pdftk

# arduino, embedded et al.
yaourt -S --noconfirm --needed arduino
sudo gpasswd -a $USER lock
sudo gpasswd -a $USER uucp
yaourt -S --noconfirm --needed fritzing

# tools
yaourt -S --noconfirm --needed etcher
sudo ln -s /opt/Etcher/etcher-electron /usr/bin/etcher-electron
yaourt -S --noconfirm --needed etcher-cli
yaourt -S --noconfirm --needed fman
yaourt -S --noconfirm --needed geteltorito
sudo pacman -S --noconfirm --needed gparted
sudo pacman -S --noconfirm --needed baobab
sudo pip install csvkit

# printer
sudo pacman -S --noconfirm --needed cups
sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service
sudo pacman -S --noconfirm --needed hplip
sudo pacman -S --noconfirm --needed system-config-printer

# scanner
sudo pacman -S --noconfirm --needed sane
sudo pacman -S --noconfirm --needed simple-scan

# nitrokey
if [ ! -f /etc/udev/rules.d/41-nitrokey.rules ]; then
  cd /tmp
  curl -LO https://www.nitrokey.com/sites/default/files/41-nitrokey.rules
  sudo mv 41-nitrokey.rules /etc/udev/rules.d/ && cd -
fi
sudo pacman -S --noconfirm --needed  ccid
yaourt -S --noconfirm --needed nitrokey-app

# signet
if [ ! -f ~/.config/Scripts/signet ]; then
  cd /tmp
  curl -LO https://nthdimtech.com/downloads/signet-releases/0.9.10/gnu-linux/signet-0.9.10
  chmod u+x signet-0.9.10
  mv signet-0.9.10 ~/.config/Scripts/signet && cd -
fi
if [ ! -f /etc/udev/rules.d/50-signet.rules ]; then
  cd /tmp
  curl -LO https://nthdimtech.com/downloads/signet-releases/0.9.10/gnu-linux/50-signet.rules
  sudo mv 50-signet.rules /etc/udev/rules.d/ && cd -
fi

# Perkeep (née Camlistore)
if [ ! -d ~/Code/perkeep ]; then
  mkdir -p ~/Code
  cd ~/Code
  git clone https://github.com/perkeep/perkeep.git
  cd -
fi
cd ~/Code/perkeep && git pull && go run make.go
ln -sf ~/Code/perkeep/bin/camget ~/.config/Scripts/
ln -sf ~/Code/perkeep/bin/camlistored ~/.config/Scripts/
ln -sf ~/Code/perkeep/bin/camput ~/.config/Scripts/
ln -sf ~/Code/perkeep/bin/camtool ~/.config/Scripts/

# clipboard manager
yaourt -S --noconfirm --needed clipit

# GPS
yaourt -S --noconfirm --needed mytourbook_bin
