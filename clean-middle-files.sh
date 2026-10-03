#!/bin/bash
# clean-middle-files.sh
# 保留最终产物，只清理编译中间文件

set -e

CROSS="arm-buildroot-linux-gnueabihf-"
BASE="$HOME/manual-build"

echo "=========================================="
echo " 收集最终产物到 artifacts/"
echo "=========================================="
mkdir -p "$BASE/artifacts"

# U-Boot
[ -f "$BASE/uboot/src/u-boot.bin" ] && cp "$BASE/uboot/src/u-boot.bin" "$BASE/artifacts/"
[ -f "$BASE/uboot/src/u-boot" ]     && cp "$BASE/uboot/src/u-boot"     "$BASE/artifacts/"

# 内核
[ -f "$BASE/kernel/linux-6.12.27/arch/arm/boot/zImage" ] && \
    cp "$BASE/kernel/linux-6.12.27/arch/arm/boot/zImage" "$BASE/artifacts/"
[ -f "$BASE/kernel/linux-6.12.27/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb" ] && \
    cp "$BASE/kernel/linux-6.12.27/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb" "$BASE/artifacts/"
[ -f "$BASE/kernel/linux-6.12.27/System.map" ] && \
    cp "$BASE/kernel/linux-6.12.27/System.map" "$BASE/artifacts/"
[ -f "$BASE/kernel/linux-6.12.27/.config" ] && \
    cp "$BASE/kernel/linux-6.12.27/.config" "$BASE/artifacts/kernel.config"

# BusyBox
[ -f "$BASE/busybox/busybox-1.37.0/busybox" ] && \
    cp "$BASE/busybox/busybox-1.37.0/busybox" "$BASE/artifacts/"
[ -f "$BASE/busybox/busybox-1.37.0/.config" ] && \
    cp "$BASE/busybox/busybox-1.37.0/.config" "$BASE/artifacts/busybox.config"

# rootfs
[ -f "$BASE/rootfs.ext4" ] && cp "$BASE/rootfs.ext4" "$BASE/artifacts/"

echo "产物清单："
ls -lh "$BASE/artifacts/"
echo ""

echo "=========================================="
echo " 清理 U-Boot 中间文件"
echo "=========================================="
cd "$BASE/uboot/src"
make ARCH=arm CROSS_COMPILE="$CROSS" clean
du -sh .

echo ""
echo "=========================================="
echo " 清理 BusyBox 中间文件"
echo "=========================================="
cd "$BASE/busybox/busybox-1.37.0"
make clean
du -sh .

echo ""
echo "=========================================="
echo " 清理内核中间文件"
echo "=========================================="
cd "$BASE/kernel/linux-6.12.27"
make ARCH=arm CROSS_COMPILE="$CROSS" clean

# 补充手动清理
find . -name "*.o" -type f -delete 2>/dev/null || true
find . -name "*.cmd" -type f -delete 2>/dev/null || true
find . -name "*.d" -type f -delete 2>/dev/null || true
find . -name "*.su" -type f -delete 2>/dev/null || true
find . -name "*.a" -type f -delete 2>/dev/null || true
find . -name "*.ko" -type f -delete 2>/dev/null || true
du -sh .

echo ""
echo "=========================================="
echo " 清理完成，最终状态"
echo "=========================================="
du -sh "$BASE"
echo ""
echo "artifacts/ 内容："
ls -lh "$BASE/artifacts/"
