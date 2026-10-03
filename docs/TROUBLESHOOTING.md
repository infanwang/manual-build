
常见错误与解决
U-Boot
bad value 'generic-armv7-a' for '-mtune='
CROSS_COMPILE 未导出。检查 export。

gnutls/gnutls.h: No such file or directory
bash
sudo apt install -y libgnutls28-dev
内核
dt-bindings/interrupt-controller/arm-gic.h: No such file
符号链接缺失。手动创建：

bash
mkdir -p arch/arm/boot/dts/include
ln -sf ../../../../../include/dt-bindings arch/arm/boot/dts/include/dt-bindings
绝不要 make dtbs_clean。

BusyBox
sha1_process_block64_shaNI undeclared
bash
sed -i 's/^CONFIG_SHA1_HWACCEL=y/# CONFIG_SHA1_HWACCEL is not set/' .config
sed -i 's/^CONFIG_SHA256_HWACCEL=y/# CONFIG_SHA256_HWACCEL is not set/' .config
TCA_CBQ_MAX undeclared
bash
sed -i 's/^CONFIG_TC=y/# CONFIG_TC is not set/' .config
QEMU
can't access tty; job control turned off
正常警告，不影响使用。

whoami: unknown uid 0
sh
cat > /etc/passwd << 'EOF'
root:x:0:0:root:/root:/bin/sh
