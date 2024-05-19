#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
  libvirt \
  virt-manager \
  edk2-ovmf

systemctl enable swtpm-workaround.service
