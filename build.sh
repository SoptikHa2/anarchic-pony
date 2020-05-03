#!/bin/bash
# This needs to be launched with sudo
if [ "$EUID" -ne 0 ]; then
    echo "This needs to be run as root."
    exit 1
fi
# We need to have ponyos iso here
if [ ! -f ponyos.iso ]; then
    echo "Please download PonyOS v5.0. Other versions might not work at all."
    echo "See https://github.com/klange/ponyos/releases/"
    echo "After you're done, place »ponyos.iso« to root directory of this project."
    exit 2
fi

set -euo pipefail

# Copy new releng copy
rm -rf releng
cp -r /usr/share/archiso/configs/releng .

# Apply patches
patch releng/packages.x86_64 packages.x86_64.patch
patch releng/airootfs/root/customize_airootfs.sh customize_airootfs.sh.patch

# Copy important files
cp ponyos.iso releng/airootfs/root/
cp patch-bootloader.awk releng/airootfs/root/
cp init-script.sh releng/airootfs/root/
cp skull.txt releng/airootfs/root/
