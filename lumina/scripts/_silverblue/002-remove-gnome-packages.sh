#!/usr/bin/env bash

set -euox pipefail
source /etc/os-release

FEDORA_VERSION=$VERSION_ID

dnf remove -y \
  gnome-tour \
  gnome-extensions-app \
  gnome-system-monitor \
  yelp
