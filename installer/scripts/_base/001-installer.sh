#!/usr/bin/env bash

set -euox pipefail

dnf install -y \
  anaconda \
  anaconda-install-env-deps \
  anaconda-live \
  anaconda-webui \
  dracut-live \
  grub2-efi-x64-cdboot \
  livesys-scripts

sed -i 's/^livesys_session=.*/livesys_session="gnome"/' /etc/sysconfig/livesys
