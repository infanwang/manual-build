#!/bin/bash
set -e
cd "$(dirname "$0")/../busybox"
BVER=1.37.0
BDIR="busybox-$BVER"
if [ ! -d "$BDIR" ]; then
    [ ! -f "$BDIR.tar.bz2" ] && wget https://busybox.net/downloads/$BDIR.tar.bz2
    bzip2 -t $BDIR.tar.bz2
    tar xf $BDIR.tar.bz2
fi
cd "$BDIR"
make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/^CONFIG_SHA1_HWACCEL=y/# CONFIG_SHA1_HWACCEL is not set/' .config
sed -i 's/^CONFIG_SHA256_HWACCEL=y/# CONFIG_SHA256_HWACCEL is not set/' .config
sed -i 's/^CONFIG_TC=y/# CONFIG_TC is not set/' .config
make olddefconfig
make -j$(nproc)
mkdir -p ../../artifacts
cp busybox ../../artifacts/
cp .config ../../artifacts/busybox.config
echo "✅ BusyBox: $(ls -lh ../../artifacts/busybox | awk '{print $5}')"
