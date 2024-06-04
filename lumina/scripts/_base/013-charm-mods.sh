#!/usr/bin/bash

set -euox pipefail

rpm-ostree install \
  $(curl https://api.github.com/repos/charmbracelet/mods/releases/latest | jq -r '.assets[] | select(.name| test(".*.x86_64.rpm$")).browser_download_url')
