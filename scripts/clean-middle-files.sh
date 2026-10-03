#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BASE"
[ -d uboot/src ] && (cd uboot/src && make clean)
[ -d kernel/linux-6.12.27 ] && (cd kernel/linux-6.12.27 && make clean)
[ -d busybox/busybox-1.37.0 ] && (cd busybox/busybox-1.37.0 && make clean)
echo "✅ 中间文件已清理"
sudo fstrim -av
echo ""
echo "在 Windows PowerShell 中压缩虚拟磁盘："
echo "  wsl --shutdown"
echo "  diskpart → select vdisk → attach readonly → compact → detach → exit"
