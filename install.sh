#!/bin/bash -x
set -euo pipefail
IFS=$'\n\t'

apt-get install -y exiftool at

set +x
echo "Copying scripts into system locations..."
set -x

cp -av config/systemd/* /etc/systemd/system/
cp -av src/* /usr/local/bin/
cp -av destinations/ssh-copy-and-organize/piphoto-ssh-sync /usr/local/bin/
cp -av destinations/dropbox/piphoto-dropbox-sync /usr/local/bin/
cp -av config/udev/* /etc/udev/rules.d/

udevadm control --reload
systemctl daemon-reload
systemctl enable piphoto.service

set +x
echo "piphoto executables and udev rules installed."
echo " - Create /etc/piphoto.conf if it doesn't exist..."
echo " - If using Dropbox destination, follow instructions in that README"
echo "   to install the dropbox_uploader script"