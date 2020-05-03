#!/bin/sh
# This is added to airootfs

# Mount all filesystems until we found one with /boot partition
for partition in /dev/disk/by-id/*; do
    fname=$(basename "$partition")
    mkdir "$fname"
    mount -o rw "$partition" "$fname"
    if [ -d "$fname/boot" ] && [ -d "$fname/boot/grub" ] && [ -f "$fname/boot/grub/grub.cfg" ]; then
        echo "Found match on partition $fname"
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
    fi
    umount "$fname"
    rm -d "$fname"
done