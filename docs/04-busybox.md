
BusyBox 静态编译
为什么必须静态编译
rootfs 里没有 glibc，动态编译的 BusyBox 无法运行。

步骤
bash
cd ~/manual-build/busybox
wget https://busybox.net/downloads/busybox-1.37.0.tar.bz2
bzip2 -t busybox-1.37.0.tar.bz2
tar xf busybox-1.37.0.tar.bz2
cd busybox-1.37.0

make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config

# 关闭与新内核不兼容的功能
sed -i 's/^CONFIG_SHA1_HWACCEL=y/# CONFIG_SHA1_HWACCEL is not set/' .config
sed -i 's/^CONFIG_SHA256_HWACCEL=y/# CONFIG_SHA256_HWACCEL is not set/' .config
sed -i 's/^CONFIG_TC=y/# CONFIG_TC is not set/' .config

make olddefconfig
make -j$(nproc)
file busybox    # 应显示 statically linked
常见编译错误
sha1_process_block64_shaNI undeclared
禁用 CONFIG_SHA1_HWACCEL 和 CONFIG_SHA256_HWACCEL。

TCA_CBQ_MAX undeclared
禁用 CONFIG_TC。

安装到 rootfs
bash
make install CONFIG_PREFIX=~/manual-build/rootfs
