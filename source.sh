#!/usr/bin/env bash
set -eu

ROOT=$(pwd)

UPSTREAMKERNELVER=$(curl -s https://api.github.com/repos/microsoft/WSL2-Linux-Kernel/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
test -d $KERNELDIR/.git || git clone --branch $UPSTREAMKERNELVER --single-branch --depth 1 https://github.com/microsoft/WSL2-Linux-Kernel.git $KERNELDIR

pushd $KERNELDIR
make olddefconfig
make prepare
popd

UPSTREAMZFSVER=$(curl -s https://api.github.com/repos/openzfs/zfs/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
test -d $ZFSDIR/.git || git clone --branch $UPSTREAMZFSVER --depth 1 https://github.com/zfsonlinux/zfs.git $ZFSDIR

pushd $ZFSDIR
./autogen.sh
./configure --enable-linux-builtin --with-linux=$ROOT/$KERNELDIR --with-linux-obj=$ROOT/$KERNELDIR
./copy-builtin $ROOT/$KERNELDIR
popd

echo "CONFIG_ZFS=m" >> $KERNELDIR/$KCONFIG_CONFIG
