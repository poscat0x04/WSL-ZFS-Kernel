#!/usr/bin/env sh
set -eu

pushd $KERNELDIR
make -j$(nproc) LOCALVERSION=with-zfs
