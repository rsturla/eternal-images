#!/usr/bin/env bash

set -euox pipefail

# Setup repos
cat << EOF > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

cat << EOF > /etc/yum.repos.d/google-cloud-sdk.repo
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install development tools
dnf install -y \
  code \
  libxcrypt-compat \
  google-cloud-cli \
  ripgrep \
  socat  # Required for sandboxing in Claude Code

dnf install -y https://api2.cursor.sh/updates/download/golden/linux-x64-rpm/cursor/latest

rm -f /etc/yum.repos.d/vscode.repo
rm -f /etc/yum.repos.d/google-cloud-sdk.repo
