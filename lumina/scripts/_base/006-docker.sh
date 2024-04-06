#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker.socket

rm -f /etc/yum.repos.d/docker-ce.repo
