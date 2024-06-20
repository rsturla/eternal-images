#!/usr/bin/env bash

set -euox pipefail

# Setup repo
cat << EOF > /etc/yum.repos.d/github.repo
[gh-cli]
name=packages for the GitHub CLI
baseurl=https://cli.github.com/packages/rpm
enabled=1
gpgkey=https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x23F3D4EA75716059
EOF

# Install development tools
rpm-ostree install $(curl https://api.github.com/repos/wagoodman/dive/releases/latest | jq -r '.assets[] | select(.name| test(".*_linux_amd64.rpm$")).browser_download_url')
curl -Lo /tmp/devbox https://releases.jetpack.io/devbox
install -c -m 0755 /tmp/devbox /usr/bin/devbox
rpm-ostree install \
  gh zstd

rm /etc/yum.repos.d/github.repo
