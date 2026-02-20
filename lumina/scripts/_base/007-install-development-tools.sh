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
  strace \
  patch \
  socat  # Required for sandboxing in Claude Code

dnf install -y https://api2.cursor.sh/updates/download/golden/linux-x64-rpm/cursor/latest

rm -f /etc/yum.repos.d/vscode.repo
rm -f /etc/yum.repos.d/google-cloud-sdk.repo

# Chunkah: the .py source files are RPM-owned, but dnf generates ~239 MiB of
# .pyc bytecode at install time which is unowned.  Tag the entire SDK tree so
# it merges into the rpm/google-cloud-cli component.
setfattr -n user.component -v "rpm/google-cloud-cli" /usr/lib64/google-cloud-sdk
find /usr/lib64/google-cloud-sdk -mindepth 1 -exec setfattr -n user.component -v "rpm/google-cloud-cli" {} \;
