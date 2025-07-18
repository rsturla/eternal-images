#!/usr/bin/bash

set -euox pipefail

# Extract the architecture from the kernel package
arch=$(rpm -q kernel --qf "%{ARCH}\n" | head -n1)

# Fetch the latest release and install the corresponding RPM package
dnf install -y \
  python3-ramalama \
  $(ghcurl "https://api.github.com/repos/charmbracelet/mods/releases/latest" | \
  jq -r --arg arch "$arch" '.assets[] | select(.name | test(".*\\." + $arch + "\\.rpm$")).browser_download_url')
