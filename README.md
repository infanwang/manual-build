# Manual ARM Linux Build from Scratch

从零手工构建一个完整的 ARM Linux 系统，运行在 QEMU vexpress-a9 虚拟开发板上。

不使用 Buildroot 或 Yocto，而是手工完成每一步——理解嵌入式 Linux 的每个组件从哪来。

## 目标平台

| 项目 | 值 |
|---|---|
| 开发板 | ARM Versatile Express (vexpress-a9) |
| CPU | ARM Cortex-A9 (ARMv7) |
| 内核 | Linux 6.12.27 |
| Bootloader | U-Boot 2025.01 |
| Rootfs | BusyBox 1.37.0 (静态) + ext4 |
| 运行环境 | QEMU 8.x+ |

## 环境要求

- Linux 主机（WSL2 / Ubuntu 24.04+）
- 磁盘空间 >= 30 GB
- 内存 >= 8 GB

```bash
sudo apt install -y build-essential git bc bison flex \
    libssl-dev libncurses-dev device-tree-compiler \
    libgnutls28-dev qemu-system-arm
快速开始
bash
git clone <your-repo-url> manual-build
cd manual-build
./scripts/build-all.sh
./scripts/start-qemu.sh
目录结构
text
manual-build/
├── docs/          # 技术文档
├── scripts/       # 构建脚本
├── artifacts/     # 最终产物（不提交）
├── kernel/        # 内核源码（不提交）
├── uboot/         # U-Boot 源码（不提交）
└── busybox/       # BusyBox 源码（不提交）
文档索引
文档	内容
01-toolchain.md	交叉工具链
02-uboot.md	U-Boot 编译
03-kernel.md	内核 + 设备树
04-busybox.md	BusyBox
05-rootfs.md	根文件系统
06-qemu-boot.md	QEMU 启动
TROUBLESHOOTING.md	踩坑记录
核心知识点
交叉编译三元组：arm-buildroot-linux-gnueabihf-

设备树符号链接：dt-bindings 需手动创建

BusyBox 必须静态编译

启动参数：root=/dev/mmcblk0 rw console=ttyAMA0 init=/init

License
MIT
