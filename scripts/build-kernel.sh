#!/bin/bash
set -e
cd "$(dirname "$0")/../kernel"
KVER=6.12.27
KDIR="linux-$KVER"
if [ ! -d "$KDIR" ]; then
    [ ! -f "$KDIR.tar.xz" ] && wget https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/$KDIR.tar.xz
    xz -t $KDIR.tar.xz
    tar xf $KDIR.tar.xz
fi
cd "$KDIR"
make vexpress_defconfig
if [ ! -e arch/arm/boot/dts/include/dt-bindings ]; then
    mkdir -p arch/arm/boot/dts/include
    ln -sf ../../../../../include/dt-bindings arch/arm/boot/dts/include/dt-bindings
fi
make zImage dtbs -j$(nproc)
mkdir -p ../../artifacts
cp arch/arm/boot/zImage ../../artifacts/
cp arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb ../../artifacts/
cp System.map ../../artifacts/
cp .config ../../artifacts/kernel.config
echo "✅ Kernel: $(ls -lh ../../artifacts/zImage | awk '{print $5}')"
