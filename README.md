# anarchic-pony
Live ISO that boots Archlinux, and if user has GRUB installed, automatically sets up PonyOS as default grub entry. That's all.

## Developing

We use `/usr/share/archiso/configs/releng/` as base, as described [here](https://wiki.archlinux.org/index.php/Archiso). There are several patch files which need to be applied before continuing with generating the archiso.

Create patch file:
```
diff <old> <new> > <patchfile>
```

Apply patch file:
```
patch <old> <patch>
```

## Build
Call `build.sh` as root. That will apply patches to the iso file.
