#!/usr/bin/bash

set -euox pipefail

# Download yt-dlp from GitHub releases
ghcurl "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" -o /tmp/yt-dlp
install -c -m 0755 /tmp/yt-dlp /usr/bin/yt-dlp
