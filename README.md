# bare-linux-experiment
Files for "bare linux" experiment

### Brief steps

Create new virtual machine with hard disk of about 100Mb, e.g. in VirtualBox. Use some LiveCD, e.g. SystemRescueCD, preferably with Linux.

Use `fdisk` or `gparted` to prepare disk - you'll need at least one partition obviously. I created MBR partitioning table and one partition.

Install some boot software - I used `extlinux` though systemd-boot and grub2 are also available. I installed `extlinux` to `/boot` of the
partition.

Probably it is necessary also to write MBR code (find `mbr.bin` and `cat` it to `/dev/sda`).

Place `vmlinuz*` files at the same directory and `initrd*` files also.

Now try booting. at extlinux prompt `boot:` enter the kernel and initrd path in form

    /boot/vmlinuz64 initrd=/boot/initrd-asm

### Initrd preparation

These files are prepared by compiling given sources, e.g. (any of two)

    gcc -o init -static init.c

    as --32 init.s
    ld -m elf_i386 -o init a.out

then create image with cpio:

    echo init | cpio -o --format=newc > initrd

Of course you can also fetch ready initrd file from some linux distribution.
