#!/bin/bash
set -e
cd "$(dirname "$0")/../uboot"
if [ ! -d src ]; then
    git clone --depth=1 -b v2025.01 https://source.denx.de/u-boot/u-boot.git src
fi
cd src
make vexpress_ca9x4_defconfig
make -j$(nproc)
mkdir -p ../../artifacts
cp u-boot.bin ../../artifacts/
echo "✅ U-Boot: $(ls -lh u-boot.bin | awk '{print $5}')"
