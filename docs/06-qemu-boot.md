# QEMU 启动验证

## 方式 1：直接启动内核（最快）

```bash
qemu-system-arm \
    -M vexpress-a9 -m 256M \
    -kernel kernel/linux-6.12.27/arch/arm/boot/zImage \
    -dtb kernel/linux-6.12.27/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb \
    -drive file=rootfs.ext4,format=raw,if=sd \
    -append "root=/dev/mmcblk0 rw console=ttyAMA0 init=/init" \
    -nographic
方式 2：通过 U-Boot 启动（完整启动链）
准备 SD 卡镜像
bash
# 创建 128MB SD 卡镜像（必须是 2 的幂）
dd if=/dev/zero of=sdcard.img bs=1M count=128

# 分区：32MB FAT + 95MB ext4
sudo fdisk sdcard.img << 'FDISK_EOF'
n
p
1

+32M
n
p
2


t
1
c
w
FDISK_EOF

# 挂载 loop
sudo losetup -fP sdcard.img
LOOP=$(losetup -a | grep sdcard | cut -d: -f1)

# 格式化
sudo mkfs.vfat ${LOOP}p1
sudo mkfs.ext4 -F ${LOOP}p2

# 复制内核
sudo mkdir -p /mnt/boot /mnt/root
sudo mount ${LOOP}p1 /mnt/boot
sudo cp kernel/linux-6.12.27/arch/arm/boot/zImage /mnt/boot/
sudo cp kernel/linux-6.12.27/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb /mnt/boot/
sudo umount /mnt/boot

# 复制 rootfs
sudo mount ${LOOP}p2 /mnt/root
sudo cp -a rootfs/. /mnt/root/
sudo umount /mnt/root
sudo losetup -d $LOOP
启动 QEMU + U-Boot
bash
qemu-system-arm \
    -M vexpress-a9 -m 256M \
    -kernel artifacts/u-boot \
    -drive file=sdcard.img,format=raw,if=sd \
    -nographic
在 U-Boot 提示符（=>）下执行
text
setenv bootcmd 'fatload mmc 0:1 0x60008000 zImage; fatload mmc 0:1 0x61000000 vexpress-v2p-ca9.dtb; setenv bootargs root=/dev/mmcblk0p2 rw console=ttyAMA0 init=/init; bootz 0x60008000 - 0x61000000'
run bootcmd
注意：

=> 是 U-Boot 提示符，只接受 U-Boot 命令

~ # 是 BusyBox 提示符，只接受 Linux 命令

两者不能混用

预期启动日志
text
U-Boot 2025.01 ...
Hit any key to stop autoboot:  0
=>

=> run bootcmd
5897952 bytes read in 2356 ms (2.4 MiB/s)
14329 bytes read in 15 ms (932.6 KiB/s)
Kernel image @ 0x60008000 [ 0x000000 - 0x59fee0 ]
## Flattened Device Tree blob at 61000000
   Booting using the fdt blob at 0x61000000
Working FDT set to 61000000
   Loading Device Tree to 6eae8000, end 6eaee7f8 ... OK

Starting kernel ...

Booting Linux on physical CPU 0x0
Linux version 6.12.27 ...
...
EXT4-fs (mmcblk0p2): mounted filesystem ...
Run /init as init process

==========================================
  Manual Buildroot for ARM
  Kernel: 6.12.27
  Arch:   armv7l
==========================================

~ #
在 QEMU 里验证
sh
uname -a
cat /proc/cpuinfo
df -h
free -h
mount
ls /
busybox --list | wc -l    # 应显示 402
退出 QEMU
Ctrl+A，松开，按 X

常见问题
问题	原因	解决
Card did not respond to voltage select!	没有 SD 卡	加 -drive file=sdcard.img,...
Invalid SD card size: 96 MiB	大小不是 2 的幂	用 128MB
Wrong image format for "source"	boot.scr 格式不兼容	用 run bootcmd 手动启动
Kernel panic: Attempted to kill init	在 BusyBox 里敲 exit	PID 1 不能退出，用 Ctrl+A, X
