#!/usr/bin/env bash

set -euox pipefail

# Setup repos
cat << EOF > /etc/yum.repos.d/github.repo
[gh-cli]
name=packages for the GitHub CLI
baseurl=https://cli.github.com/packages/rpm
enabled=1
gpgkey=https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x23F3D4EA75716059
EOF

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
  code \
  gh \
  git-credential-oauth

# Install Kind
curl --retry 3 -Lo /tmp/kind https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64
install -c -m 0755 /tmp/kind /usr/bin/kind
DOWNLOAD_URL=$(curl https://api.github.com/repos/kubernetes-sigs/cloud-provider-kind/releases/latest | jq -r '.assets[] | select(.name| test("_linux_amd64.tar.gz$")).browser_download_url')
curl --retry 3 -Lo /tmp/cloud-provider-kind $DOWNLOAD_URL
tar -xzf /tmp/cloud-provider-kind.tar.gz -C /tmp
install -c -m 0755 /tmp/cloud-provider-kind /usr/bin/cloud-provider-kind

# Install Devbox
curl --retry 3 -Lo /tmp/devbox https://releases.jetpack.io/devbox
install -c -m 0755 /tmp/devbox /usr/bin/devbox

rm -f /etc/yum.repos.d/github.repo
rm -f /etc/yum.repos.d/vscode.repo
