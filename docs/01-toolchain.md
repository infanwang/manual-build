# 交叉工具链准备

## 方案 A：复用 Buildroot 工具链（推荐）

```bash
export PATH=$PATH:~/buildroot-2025.02.3/output/host/bin
export CROSS_COMPILE=arm-buildroot-linux-gnueabihf-
export ARCH=arm
${CROSS_COMPILE}gcc --version
方案 B：Linaro 官方工具链
bash
wget https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
tar xf gcc-linaro-*.tar.xz -C ~/toolchains/
export PATH=$PATH:~/toolchains/gcc-linaro-*/bin
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
方案 C：crosstool-NG 自建
bash
git clone https://github.com/crosstool-ng/crosstool-ng.git
cd crosstool-ng
./configure --prefix=/opt/crosstool-ng
make -j$(nproc) && sudo make install
export PATH=/opt/crosstool-ng/bin:$PATH
mkdir ~/ct-ng && cd ~/ct-ng
ct-ng arm-unknown-linux-gnueabihf
ct-ng build
持久化到 ~/.bashrc
bash
cat >> ~/.bashrc << 'BASH_EOF'
export PATH=$PATH:~/buildroot-2025.02.3/output/host/bin
export CROSS_COMPILE=arm-buildroot-linux-gnueabihf-
export ARCH=arm
BASH_EOF
source ~/.bashrc
验证
bash
echo $CROSS_COMPILE
echo $ARCH
${CROSS_COMPILE}gcc --version
