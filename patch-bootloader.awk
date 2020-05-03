BEGIN {
    target_nr = -1
}

/END \/etc\/grub\.d\/00_header/ {
    target_nr = NR + 1
}

NR == target_nr {
    # Patch in payload
    print "menuentry \"Pony OS\" {"
    print "    set isofile=\"/boot/ponyos.iso\""
    print "    loopback loop $isofile"
    print "    set root=\"(loop)\""
    print "    configfile \"/boot/grub/grub.cfg\""
    print "}"
}

# Actually print each line of source file
/^.*$/ { print $0 }
