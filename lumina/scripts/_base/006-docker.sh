#!/usr/bin/env bash

set -euox pipefail

# Setup repo
cat << EOF > /etc/yum.repos.d/docker-ce.repo
[docker-ce-stable]
name=Docker CE Stable
baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
enabled=0
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg

[docker-ce-testing]
name=Docker CE Testing
baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

DOCKER_REPO=stable
#FEDORA_VERSION=$(rpm -E %fedora)
#if [[ "$FEDORA_VERSION" -eq 42 ]]; then
#    DOCKER_REPO=testing
#fi

dnf install -y --enablerepo=docker-ce-$DOCKER_REPO \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker.socket

rm -f /etc/yum.repos.d/docker-ce.repo
