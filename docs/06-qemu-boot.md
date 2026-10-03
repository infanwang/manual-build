
QEMU 启动验证
安装 QEMU
bash
sudo apt install -y qemu-system-arm
启动
bash
cd ~/manual-build
qemu-system-arm \
    -M vexpress-a9 -m 256M \
    -kernel kernel/linux-6.12.27/arch/arm/boot/zImage \
    -dtb kernel/linux-6.12.27/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb \
    -drive file=rootfs.ext4,format=raw,if=sd \
    -append "root=/dev/mmcblk0 rw console=ttyAMA0 init=/init" \
    -nographic
参数
参数	含义
-M vexpress-a9	模拟 ARM vexpress 板
-m 256M	内存
-kernel / -dtb	内核 / 设备树
-drive file=...,if=sd	rootfs 作为 SD 卡
-append "root=..."	内核启动参数
-nographic	用终端
预期输出
text
Booting Linux on physical CPU 0x0
Linux version 6.12.27 ...
EXT4-fs (mmcblk0): mounted filesystem ...
Run /init as init process
Welcome to Manual Buildroot
~ #
退出
Ctrl+A，松开，按 X。
