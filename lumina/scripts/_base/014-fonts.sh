#!/usr/bin/bash

set -euox pipefail

# GitHub Monaspace
DOWNLOAD_URL=$(ghcurl "https://api.github.com/repos/githubnext/monaspace/releases/latest" | jq -r '.assets[] | select(.name| test(".*.zip$")) .browser_download_url')
ghcurl "$DOWNLOAD_URL" -o /tmp/monaspace-font.zip

unzip -qo /tmp/monaspace-font.zip -d /tmp/monaspace-font
mkdir -p /usr/share/fonts/monaspace
mv /tmp/monaspace-font/monaspace-v*/fonts/otf/* /usr/share/fonts/monaspace/
mv /tmp/monaspace-font/monaspace-v*/fonts/variable/* /usr/share/fonts/monaspace/

fc-cache -f /usr/share/fonts/monaspace
