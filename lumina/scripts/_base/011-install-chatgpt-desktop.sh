#!/usr/bin/env bash

set -ouex pipefail

arch=$(rpm -q kernel --qf "%{ARCH}\n" | head -n1)

if [[ "$arch" == "aarch64" ]]; then
    echo "ChatGPT Desktop does not currently provide aarch64 packages"
    exit 0
fi

mkdir -p /var/opt

dnf install -y \
  "https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.${arch}.rpm"

if [[ -d /var/opt/ChatGPT ]]; then
  mv /var/opt/ChatGPT /usr/lib/ChatGPT

  cat >/usr/lib/tmpfiles.d/eternal-chatgpt.conf <<EOF
L  /opt/ChatGPT  -  -  -  -  /usr/lib/ChatGPT
EOF

  setfattr -n user.component -v "rpm/chatgpt" /usr/lib/ChatGPT
  find /usr/lib/ChatGPT -mindepth 1 -exec setfattr -n user.component -v "rpm/chatgpt" {} \;
fi
