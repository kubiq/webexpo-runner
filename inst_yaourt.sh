#!/bin/sh

echo '[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
pacman -Sy --noconfirm yaourt

groupadd --system sudo
useradd -m --groups sudo user
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
