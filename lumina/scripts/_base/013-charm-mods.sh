#!/usr/bin/bash

set -euox pipefail

dnf install -y \
  $(curl https://api.github.com/repos/charmbracelet/mods/releases/latest | jq -r '.assets[] | select(.name| test(".*.x86_64.rpm$")).browser_download_url')
