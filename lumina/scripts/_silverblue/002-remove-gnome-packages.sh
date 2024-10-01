#!/usr/bin/env bash

set -euox pipefail
source /etc/os-release

FEDORA_VERSION=$VERSION_ID

rpm-ostree override remove \
  gnome-tour \
  gnome-extensions-app \
  gnome-system-monitor \
  yelp

if [[ "$FEDORA_VERSION" == "40" ]]; then
  rpm-ostree override remove gnome-terminal-nautilus
fi
