#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
  libvirt \
  virt-manager \
  edk2-ovmf

# Some services depend on directories in /var/log, which are not present on atomic desktops
# Another option is a systemd unit to create them, but seems overkill and the services are
# not important
systemctl disable pmcd.service
