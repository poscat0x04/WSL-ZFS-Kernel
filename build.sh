#!/usr/bin/env sh
set -eu
set -o pipefail

pushd $KERNELDIR
make -j$(nproc) LOCALVERSION=with-zfs
