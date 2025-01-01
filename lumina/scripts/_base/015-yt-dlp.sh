#!/usr/bin/bash

set -euox pipefail

curl -Lo /tmp/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
install -c -m 0755 /tmp/yt-dlp /usr/bin/yt-dlp
