#!/usr/bin/env bash

set -euox pipefail
source /etc/os-release

FEDORA_VERSION=$VERSION_ID

if [[ "$FEDORA_VERSION" == "40" ]]; then
  # Install the package
  dnf install -y ptyxis
fi

rpm-ostree install podmansh
