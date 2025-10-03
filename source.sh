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

cat <<EOF >>$KERNELDIR/$KCONFIG_CONFIG

CONFIG_ZFS=y
CONFIG_CRYPTO_ZSTD=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y

CONFIG_FRONTSWAP=y
CONFIG_ZSWAP=y
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD=y
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="zstd"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC=y
CONFIG_ZSWAP_ZPOOL_DEFAULT="zsmalloc"
CONFIG_ZSWAP_DEFAULT_ON=y
CONFIG_ZPOOL=y
CONFIG_ZSMALLOC=y
EOF
echo "tag=$UPSTREAMKERNELVER-$UPSTREAMZFSVER" >>"$GITHUB_OUTPUT"
