#!/bin/bash -x
set -euo pipefail
IFS=$'\n\t'

apt-get install -y exiftool at
cp config/systemd/* /etc/systemd/system/
cp src/* /usr/local/bin/
cp config/udev/* /etc/udev/rules.d/
udevadm control --reload
systemctl daemon-reload
systemctl enable piphoto.service
echo "Executables and udev rules installed. You'll need to create /etc/piphoto.conf if you haven't already"