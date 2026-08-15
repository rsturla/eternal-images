#!/usr/bin/env bash

set -euox pipefail

# Setup repos
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
  createrepo_c \
  openssl-devel \
  libxcrypt-compat \
  google-cloud-cli \
  ripgrep \
  strace \
  patch \
  socat  # Required for sandboxing in Claude Code

dnf install -y https://api2.cursor.sh/updates/download/golden/linux-x64-rpm/cursor/latest

rm -f /etc/yum.repos.d/google-cloud-sdk.repo

# Install Zed IDE from the upstream tarball (not packaged in Fedora repos)
curl -Lo /tmp/zed.tar.gz https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz
mkdir -p /usr/lib/zed.app/
tar -xf /tmp/zed.tar.gz -C /usr/lib/zed.app/ --strip-components=1
rm -f /tmp/zed.tar.gz
ln -s /usr/lib/zed.app/bin/zed /usr/bin/zed

# Expose the launcher and icon via symlinks so the upstream .desktop resolves
# Exec=zed (via PATH) and Icon=zed (via hicolor) without rewriting the file.
mkdir -p /usr/share/icons/hicolor/512x512/apps
ln -s /usr/lib/zed.app/share/icons/hicolor/512x512/apps/zed.png \
  /usr/share/icons/hicolor/512x512/apps/zed.png
ln -s /usr/lib/zed.app/share/applications/dev.zed.Zed.desktop \
  /usr/share/applications/dev.zed.Zed.desktop

# Chunkah: the Zed tree is not RPM-owned; tag it so it packs into its own
# component instead of landing in unclaimed files.
setfattr -n user.component -v "zed" /usr/lib/zed.app
find /usr/lib/zed.app -mindepth 1 -exec setfattr -n user.component -v "zed" {} \;

# Chunkah: the .py source files are RPM-owned, but dnf generates ~239 MiB of
# .pyc bytecode at install time which is unowned.  Tag the entire SDK tree so
# it merges into the rpm/google-cloud-cli component.
setfattr -n user.component -v "rpm/google-cloud-cli" /usr/lib64/google-cloud-sdk
find /usr/lib64/google-cloud-sdk -mindepth 1 -exec setfattr -n user.component -v "rpm/google-cloud-cli" {} \;
