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
rpm-ostree install \
  code \
  $(curl https://api.github.com/repos/wagoodman/dive/releases/latest | jq -r '.assets[] | select(.name| test(".*_linux_amd64.rpm$")).browser_download_url') \
  gh

curl -Lo /tmp/devbox https://releases.jetpack.io/devbox
install -c -m 0755 /tmp/devbox /usr/bin/devbox

# Install Zed IDE (https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz)
curl -Lo /tmp/zed.tar.gz https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz
mkdir -p /usr/lib/zed.app/
tar -xvf /tmp/zed.tar.gz -C /usr/lib/zed.app/
ln -s /usr/lib/zed.app/bin/zed /usr/bin/zed

rm -f /etc/yum.repos.d/github.repo
rm -f /etc/yum.repos.d/vscode.repo
