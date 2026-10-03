
U-Boot 编译
步骤
bash
cd ~/manual-build/uboot
git clone --depth=1 -b v2025.01 https://source.denx.de/u-boot/u-boot.git src
cd src
make vexpress_ca9x4_defconfig
make -j$(nproc)
常见错误
bad value 'generic-armv7-a' for '-mtune='
CROSS_COMPILE 未导出，用了 x86 gcc。

bash
export CROSS_COMPILE=arm-buildroot-linux-gnueabihf-
export ARCH=arm
make distclean
make vexpress_ca9x4_defconfig
make -j$(nproc)
gnutls/gnutls.h: No such file or directory
bash
sudo apt install -y libgnutls28-dev
或禁用：

bash
echo "CONFIG_TOOLS_MKEFICAPSULE=n" >> .config
make olddefconfig
make -j$(nproc)
产物
文件	大小
u-boot	5.0M
u-boot.bin	590K
u-boot.srec	1.8M
