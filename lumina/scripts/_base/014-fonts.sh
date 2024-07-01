#!/usr/bin/bash

set -euox pipefail

rpm-ostree install \
  $(curl https://api.github.com/repos/charmbracelet/mods/releases/latest | jq -r '.assets[] | select(.name| test(".*.x86_64.rpm$")).browser_download_url')


# TODO: Dynamically fetch the latest release
DOWNLOAD_URL=$(curl https://api.github.com/repos/githubnext/monaspace/releases/latest | jq -r '.assets[] | select(.name| test(".*.zip$")).browser_download_url')
curl -Lo /tmp/monospace-font.zip $DOWNLOAD_URL

unzip -o /tmp/monospace-font.zip -d /tmp/monospace-font
mv /tmp/monospace-font/monaspace-v*/fonts/otf/* /usr/share/fonts/
mv /tmp/monospace-font/monaspace-v*/fonts/variable/* /usr/share/fonts/
