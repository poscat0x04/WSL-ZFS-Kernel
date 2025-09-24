#!/usr/bin/env bash
set -eu

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && \
sudo apt-get --autoremove upgrade -y && \
sudo apt-get install -y tzdata && \
sudo apt-get install -y \
  alien \
  autoconf \
  automake \
  bc \
  binutils \
  bison \
  build-essential \
  curl \
  dkms \
  dwarves \
  fakeroot \
  flex \
  gawk \
  libaio-dev \
  libattr1-dev \
  libblkid-dev \
  libelf-dev \
  libffi-dev \
  libssl-dev \
  libtirpc-dev \
  libtool \
  libudev-dev \
  python3 \
  python3-cffi \
  python3-dev \
  python3-setuptools \
  uuid-dev \
  wget \
  zlib1g-dev
