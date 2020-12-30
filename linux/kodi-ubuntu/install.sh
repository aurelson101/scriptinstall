#!/bin/bash

echo "kodi repo add"
apt install software-properties-common -y
add-apt-repository ppa:team-xbmc/ppa -y

echo "Update and upgrade"
apt update -y && apt upgrade -y

echo "Install kodi and screen output"
apt install kodi xinit xorg dbus-x11 xserver-xorg-video-intel xserver-xorg-legacy pulseaudio upower -y

echo "Add User for Kodi"
adduser --disabled-password --disabled-login --gecos "" kodi

echo "Add user to groups"
usermod -a -G audio,video,input,dialout,plugdev,tty kodi

echo "Edit /etc/X11/Xwrapper.config and replace allowed_users=console for allowed_users=anybody"
sed -ie 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config

echo "dd to the end of /etc/X11/Xwrapper.config"
echo "needs_root_rights=yes" >> /etc/X11/Xwrapper.config

echo "CP kodi.service to the correct place"
cp kodi.service /etc/systemd/system

echo "CP powermenu_in_kodi.pkla to the correct place"
cp powermenu_in_kodi.pkla /etc/polkit-1/localauthority/50-local.d

echo "Start Kodi on boot"
systemctl enable kodi

echo "Start Kodi service"
systemctl start kodi
