#!/bin/bash
set -e
export PATH=$PATH:~/buildroot-2025.02.3/output/host/bin
export CROSS_COMPILE=arm-buildroot-linux-gnueabihf-
export ARCH=arm
cd "$(dirname "$0")/.."

echo "===== 1/5 U-Boot ====="
bash scripts/build-uboot.sh
echo "===== 2/5 Kernel ====="
bash scripts/build-kernel.sh
echo "===== 3/5 BusyBox ====="
bash scripts/build-busybox.sh
echo "===== 4/5 Rootfs ====="
bash scripts/build-rootfs.sh
echo ""
echo "✅ 全部完成！启动：./scripts/start-qemu.sh"
