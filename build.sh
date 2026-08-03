#!/usr/bin/env bash
set -xeu

pushd $KERNELDIR

make -j$(nproc) LOCALVERSION=-with-zfs
make INSTALL_MOD_PATH=$PWD/modules modules_install

make INSTALL_HDR_PATH=$PWD/headers headers_install

make -C tools/perf NO_JEVENTS= NO_JVMTI=1 NO_LIBTRACEEVENT=1 DESTDIR=$PWD/perf prefix=/ install

./Microsoft/scripts/gen_artifacts_vhdx.sh "$PWD/modules" "$PWD/headers" "$PWD/perf" $(make -s kernelrelease LOCALVERSION=-with-zfs) modules.vhdx

du -h modules.vhdx
