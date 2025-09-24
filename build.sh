#!/usr/bin/env bash
set -eu

pushd $KERNELDIR
make -j$(nproc) LOCALVERSION=with-zfs
