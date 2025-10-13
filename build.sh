#!/usr/bin/env bash
set -xeu

pushd $KERNELDIR
make -j$(nproc) LOCALVERSION=with-zfs
make INSTALL_MOD_PATH=$PWD/modules modules_install
sudo ./Microsoft/scripts/gen_modules_vhdx.sh "$PWD/modules" $(make -s kernelrelease LOCALVERSION=with-zfs) modules.vhdx
