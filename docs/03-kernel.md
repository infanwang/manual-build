
Linux 内核 + 设备树
下载源码
bash
cd ~/manual-build/kernel
wget https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.12.27.tar.xz
xz -t linux-6.12.27.tar.xz
tar xf linux-6.12.27.tar.xz
cd linux-6.12.27
编译
bash
make vexpress_defconfig
make zImage dtbs -j$(nproc)
关键坑：设备树符号链接
内核源码包不含 arch/arm/boot/dts/include/dt-bindings 符号链接，报错：

text
fatal error: dt-bindings/interrupt-controller/arm-gic.h: No such file or directory
手动修复：

bash
mkdir -p arch/arm/boot/dts/include
ln -sf ../../../../../include/dt-bindings arch/arm/boot/dts/include/dt-bindings
make dtbs -j$(nproc)
绝不要执行 make dtbs_clean —— 它会删除这个链接。

产物
文件	大小
zImage	5.7M
vexpress-v2p-ca9.dtb	14K
System.map	2.4M
