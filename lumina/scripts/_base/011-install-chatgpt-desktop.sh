#!/usr/bin/env bash

set -ouex pipefail

arch=$(rpm -q kernel --qf "%{ARCH}\n" | head -n1)

if [[ "$arch" == "aarch64" ]]; then
    echo "ChatGPT Desktop does not currently provide aarch64 packages"
    exit 0
fi

cat << 'EOF' > /etc/yum.repos.d/chatgpt.repo
[openai-chatgpt]
name=ChatGPT
baseurl=https://persistent.oaistatic.com/codex-app-prod/linux/rpm/$basearch
enabled=1
type=rpm-md
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-chatgpt
EOF

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-chatgpt

dnf install -y chatgpt

rm -f /etc/yum.repos.d/chatgpt.repo
