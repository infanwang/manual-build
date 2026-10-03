
构建根文件系统
步骤
bash
cd ~/manual-build/rootfs
mkdir -p dev proc sys etc/init.d tmp var/log root home mnt opt

sudo mknod dev/console c 5 1
sudo mknod dev/null c 1 3
sudo chmod 600 dev/console
sudo chmod 666 dev/null

cat > init << 'INIT_EOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev 2>/dev/null || true
echo "Welcome to Manual Buildroot"
exec /bin/sh
INIT_EOF
chmod +x init
打包 ext4
bash
cd ~/manual-build
dd if=/dev/zero of=rootfs.ext4 bs=1M count=64
mkfs.ext4 -F rootfs.ext4
sudo mkdir -p /mnt/rootfs
sudo mount -o loop rootfs.ext4 /mnt/rootfs
sudo cp -a rootfs/. /mnt/rootfs/
sudo umount /mnt/rootfs
可选：/etc/passwd
bash
cat > ~/manual-build/rootfs/etc/passwd << 'PWD_EOF'
root:x:0:0:root:/root:/bin/sh
PWD_EOF
