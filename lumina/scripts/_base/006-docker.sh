#!/usr/bin/env bash

set -euox pipefail

FEDORA_VERSION=$(rpm -E %fedora)
if [[ "$FEDORA_VERSION" -eq 42 ]]; then
    echo "Docker is not currently building for this version"
    exit 0
fi

# Setup repo
cat << EOF > /etc/yum.repos.d/docker-ce.repo
[docker-ce-stable]
name=Docker CE Stable
baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

dnf install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker.socket

rm -f /etc/yum.repos.d/docker-ce.repo
