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

# Install development tools
dnf install -y \
  code

rm -f /etc/yum.repos.d/vscode.repo
