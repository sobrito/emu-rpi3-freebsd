#!/bin/sh

/etc/init.d/ssh restart
/etc/init.d/sudo restart

qemu-system-aarch64 -m 1024M \
   -cpu cortex-a57 -M virt \
   -bios /usr/src/aarch64/QEMU_EFI.fd \
   -serial telnet::23,server -nographic \
   -drive if=none,file=/usr/src/aarch64/rpi3.img,id=hd0 \
   -device virtio-blk-device,drive=hd0 \
   -device virtio-net-device,netdev=net0 \
   -netdev user,id=net0 
