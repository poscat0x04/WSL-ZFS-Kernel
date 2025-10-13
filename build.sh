#!/usr/bin/env bash
set -xeu

pushd $KERNELDIR
make -j$(nproc) LOCALVERSION=with-zfs
sudo ./Microsoft/scripts/gen_modules_vhdx.sh "$PWD/modules" $(make -s kernelrelease) modules.vhdx
