#!/bin/bash
# build-kernel-safe.sh
# 带完整性检查的内核下载/解压/编译脚本
# 幂等：已完整则跳过，不完整则重新下载

set -e

# ===== 配置 =====
KERNEL_VERSION="6.12.27"
KERNEL_DIR="$HOME/manual-build/kernel"
TARBALL="linux-${KERNEL_VERSION}.tar.xz"
SRC_DIR="linux-${KERNEL_VERSION}"
MIRROR="https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x"

# 关键文件：用于验证源码树完整性
KEY_FILE="include/dt-bindings/interrupt-controller/arm-gic.h"
# 预期 dt-bindings 文件数下限（完整源码约 200+）
MIN_DTBINDINGS_FILES=100

# 交叉编译环境
export PATH=$PATH:$HOME/buildroot-2025.02.3/output/host/bin
export CROSS_COMPILE=arm-buildroot-linux-gnueabihf-
export ARCH=arm

cd "$KERNEL_DIR"

echo "=========================================="
echo " Linux ${KERNEL_VERSION} 下载/编译"
echo "=========================================="
echo ""

# ===== 步骤 1：检查 tar 包完整性 =====
echo "[1/5] 检查 tar 包..."

need_download=0

if [ ! -f "$TARBALL" ]; then
    echo "  ❌ tar 包不存在，需要下载"
    need_download=1
else
    echo "  ✓ tar 包存在: $(du -h $TARBALL | cut -f1)"
    echo "  验证压缩包完整性..."
    if xz -t "$TARBALL" 2>/dev/null; then
        echo "  ✅ tar 包完整"
    else
        echo "  ❌ tar 包损坏（可能被中断下载），需要重新下载"
        need_download=1
    fi
fi

# ===== 步骤 2：下载（如需要） =====
if [ "$need_download" = "1" ]; then
    echo ""
    echo "[2/5] 下载内核源码..."
    # 删除损坏的 tar 包
    rm -f "$TARBALL"

    # 使用 wget 下载到临时文件，成功后重命名（原子操作）
    wget -c -O "${TARBALL}.tmp" \
        "${MIRROR}/${TARBALL}"

    # 再次验证完整性
    echo "  验证下载完整性..."
    if xz -t "${TARBALL}.tmp" 2>/dev/null; then
        mv "${TARBALL}.tmp" "$TARBALL"
        echo "  ✅ 下载完成且完整"
    else
        rm -f "${TARBALL}.tmp"
        echo "  ❌ 下载仍不完整，请重试"
        exit 1
    fi
else
    echo ""
    echo "[2/5] 跳过下载（tar 包已完整）"
fi

# ===== 步骤 3：检查源码树完整性 =====
echo ""
echo "[3/5] 检查源码树..."

need_extract=0

if [ ! -d "$SRC_DIR" ]; then
    echo "  ❌ 源码目录不存在，需要解压"
    need_extract=1
else
    echo "  ✓ 源码目录存在"

    # 检查关键文件
    if [ ! -f "$SRC_DIR/$KEY_FILE" ]; then
        echo "  ❌ 关键文件缺失: $KEY_FILE"
        need_extract=1
    else
        echo "  ✓ 关键文件存在"
    fi

    # 检查 dt-bindings 文件数量
    if [ -d "$SRC_DIR/include/dt-bindings" ]; then
        count=$(find "$SRC_DIR/include/dt-bindings" -type f 2>/dev/null | wc -l)
        echo "  dt-bindings 文件数: $count"
        if [ "$count" -lt "$MIN_DTBINDINGS_FILES" ]; then
            echo "  ❌ dt-bindings 文件数过少（< $MIN_DTBINDINGS_FILES），源码树不完整"
            need_extract=1
        fi
    else
        echo "  ❌ dt-bindings 目录不存在"
        need_extract=1
    fi
fi

# ===== 步骤 4：解压（如需要） =====
if [ "$need_extract" = "1" ]; then
    echo ""
    echo "[4/5] 解压源码..."
    rm -rf "$SRC_DIR"
    tar xf "$TARBALL"
    echo "  ✅ 解压完成"

    # 解压后再次验证
    if [ ! -f "$SRC_DIR/$KEY_FILE" ]; then
        echo "  ❌ 解压后关键文件仍缺失！tar 包可能损坏"
        exit 1
    fi

    count=$(find "$SRC_DIR/include/dt-bindings" -type f 2>/dev/null | wc -l)
    echo "  ✅ dt-bindings 文件数: $count"

    if [ "$count" -lt "$MIN_DTBINDINGS_FILES" ]; then
        echo "  ❌ 文件数仍过少，请检查 tar 包"
        exit 1
    fi
else
    echo ""
    echo "[4/5] 跳过解压（源码树完整）"
fi

# ===== 步骤 5：编译 =====
echo ""
echo "[5/5] 编译内核 + 设备树..."

cd "$SRC_DIR"

# 检查 .config 是否存在
if [ ! -f .config ]; then
    echo "  配置内核..."
    make vexpress_defconfig
fi

# 编译
make zImage dtbs -j$(nproc)

# 验证产物
echo ""
echo "===== 产物验证 ====="
if [ -f arch/arm/boot/zImage ]; then
    echo "✅ zImage: $(ls -lh arch/arm/boot/zImage | awk '{print $5}')"
fi
if [ -f arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb ]; then
    echo "✅ vexpress-v2p-ca9.dtb: $(ls -lh arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb | awk '{print $5}')"
fi

echo ""
echo "=========================================="
echo " ✅ 全部完成"
echo "=========================================="
