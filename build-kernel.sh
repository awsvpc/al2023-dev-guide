#!/bin/bash
set -e

# https://github.com/orgs/amazonlinux/repositories
# https://github.com/amzn/amzn-drivers/issues/241#issuecomment-1282274014
# https://www.artembutusov.com/how-to-rebuild-amazon-linux-kernel-in-amazon-linux
# https://docs.aws.amazon.com/linux/al2023/ug/kernel-hardening.html
# https://kspp.github.io/
# https://github.com/a13xp0p0v/linux-kernel-defence-map
#https://github.com/a13xp0p0v/kernel-hardening-checker/

# This script must be run as the root user
function is_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "This script must be run as root. Aborting."
    exit 1
  fi
};
is_root

# Install the necessary packages
sudo dnf groupinstall -y "Development Tools"

sudo dnf install -y git \
  gcc \
  make \
  bison \
  flex \
  dwarves \
  bc \
  ncurses-devel \
  elfutils-libelf-devel \
  openssl-devel

#sudo dnf install -y "kernel-devel-$(uname -r)"

# Clone the Amazon Linux kernel repo
cd ~

git config --global core.compression 0

# Linus Torvalds' mainline kernel
#git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git ~/linux

# https://github.com/amazonlinux/linux
#git clone https://github.com/amazonlinux/linux.git ~/linux

# Git clone specific version from upstream without Amazon backports and drivers
# commit 7c15117f9468c7395ce3fd0892a6f909b91d9005 (grafted, HEAD, tag: v6.1.115)
#git clone --depth 1 --branch v6.1.115 https://github.com/amazonlinux/linux.git ~/linux

# Git clone specific Amazon Linux kernel version
#git clone --single-branch --branch "kernel-6.1.96-102.176.amzn2023" https://github.com/amazonlinux/linux.git ~/linux-kernel-6.1.96-102.176.amzn2023

# https://github.com/amazonlinux/linux/tree/amazon-6.1.y/mainline
# commit 32f4252e8cd04eda65268c02d55e76c0d26418a5 (HEAD -> amazon-6.1.y/mainline, tag: kernel-amzn-v6.1, origin/amazon-6.1.y/mainline)
git clone --single-branch --branch "amazon-6.1.y/mainline" https://github.com/amazonlinux/linux.git ~/linux

# Copy the current kernel config to use as the baseline build config
cd ~/linux

# Check out the specific commit or tag for version 6.1.115
#git checkout -B 6.1.115 v6.1.115
#git checkout v6.1.115

#make mrproper
#make clean

# Use defaults
#yes "" | make oldconfig

# Update the config to ensure any new configuration options are added with their default values.
# https://github.com/amazonlinux/linux/tree/amazon-6.1.y/mainline/Documentation/admin-guide#configuring-the-kernel
#cp -v "/boot/config-${KERNEL_VERSION}" ".config"
cp -v "/boot/config-$(uname -r)" .config
make olddefconfig

#make menuconfig

# https://lkml.org/lkml/2016/3/15/196
# https://serverfault.com/questions/964322/aws-ec2-instance-works-as-t2-but-not-m4-or-c4
# PCI_MSI=y NET_VENDOR_AMAZON=y CONFIG_ENA_ETHERNET=y
# ./scripts/config -e CONFIG_NET_VENDOR_AMAZON
# ./scripts/config -m CONFIG_ENA_ETHERNET
# ./scripts/config --set-str CONFIG_LOCALVERSION "-onload_support"

./scripts/config \
  --enable CONFIG_PCI_MSI \
  --enable CONFIG_NET_VENDOR_AMAZON \
  --enable CONFIG_ENA_ETHERNET

# Build the kernel
yes "" | make -j "$(nproc)"

# Make the kernel modules
make modules -j "$(nproc)"

#sudo make modules_install
sudo make modules_install -j "$(nproc)"

#sudo make install -j "$(nproc)"

# Get the new kernel version
NEW_KERNEL_VERSION="$(make kernelversion)"
echo "Kernel Version: $NEW_KERNEL_VERSION"

# Copy the kernel config and kernel image to the boot directory
sudo cp -v ".config" "/boot/config-${NEW_KERNEL_VERSION}"
sudo cp -v "arch/$(arch)/boot/bzImage" "/boot/vmlinuz-${NEW_KERNEL_VERSION}"

# Create the initramfs image
sudo dracut -fv --kver "${NEW_KERNEL_VERSION}"

# Update grub configuration
sudo grubby --add-kernel=/boot/vmlinuz-"${NEW_KERNEL_VERSION}" --title="${NEW_KERNEL_VERSION}.amzn"
sudo grubby --set-default=/boot/vmlinuz-"${NEW_KERNEL_VERSION}"

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

#sudo systemctl reboot

#grep -E 'CONFIG_ENA_ETHERNET=|CONFIG_NET_VENDOR_AMAZON='  "/lib/modules/$(uname -r)/build/.config"
