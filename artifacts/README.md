
构建产物
二进制文件不提交 git，通过 scripts/build-all.sh 重新生成。

文件	大小	说明
zImage	5.7M	ARM 压缩内核
vexpress-v2p-ca9.dtb	14K	设备树
System.map	2.4M	内核符号表
kernel.config	105K	内核配置
u-boot.bin	590K	Bootloader
busybox	2.0M	静态用户态工具集
busybox.config	29K	BusyBox 配置
rootfs.ext4	64M	根文件系统
