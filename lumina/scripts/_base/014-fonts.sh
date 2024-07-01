#!/usr/bin/bash

set -euox pipefail

# GitHub Monaspace
DOWNLOAD_URL=$(curl https://api.github.com/repos/githubnext/monaspace/releases/latest | jq -r '.assets[] | select(.name| test(".*.zip$")).browser_download_url')
curl -Lo /tmp/monospace-font.zip $DOWNLOAD_URL

unzip -o /tmp/monospace-font.zip -d /tmp/monospace-font
mv /tmp/monospace-font/monaspace-v*/fonts/otf/* /usr/share/fonts/
mv /tmp/monospace-font/monaspace-v*/fonts/variable/* /usr/share/fonts/

fc-cache -f /usr/share/fonts/
