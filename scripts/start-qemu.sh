#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BASE"
qemu-system-arm \
    -M vexpress-a9 -m 256M \
    -kernel kernel/linux-6.12.27/arch/arm/boot/zImage \
    -dtb kernel/linux-6.12.27/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb \
    -drive file=rootfs.ext4,format=raw,if=sd \
    -append "root=/dev/mmcblk0 rw console=ttyAMA0 init=/init" \
    -nographic
