#!/usr/bin/env bash

set -ouex pipefail

arch=$(rpm -q kernel --qf "%{ARCH}\n" | head -n1)

if [[ "$arch" == "aarch64" ]]; then
    echo "ChatGPT Desktop does not currently provide aarch64 packages"
    exit 0
fi

dnf install -y \
  "https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.${arch}.rpm"

rm -f /etc/yum.repos.d/chatgpt.repo
