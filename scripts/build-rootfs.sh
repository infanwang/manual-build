#!/bin/bash
set -e
BASE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BASE/busybox/busybox-1.37.0"
make install CONFIG_PREFIX="$BASE/rootfs"
cd "$BASE/rootfs"
mkdir -p dev proc sys etc/init.d tmp var/log root home mnt opt
sudo mknod dev/console c 5 1 2>/dev/null || true
sudo mknod dev/null c 1 3 2>/dev/null || true
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
cd "$BASE"
dd if=/dev/zero of=rootfs.ext4 bs=1M count=64
mkfs.ext4 -F rootfs.ext4
sudo mkdir -p /mnt/rootfs
sudo mount -o loop rootfs.ext4 /mnt/rootfs
sudo cp -a rootfs/. /mnt/rootfs/
sudo umount /mnt/rootfs
cp rootfs.ext4 artifacts/
echo "✅ rootfs: $(ls -lh rootfs.ext4 | awk '{print $5}')"
