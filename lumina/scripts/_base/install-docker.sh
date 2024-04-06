#!/usr/bin/env bash

set -euo pipefail

rpm-ostree install \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker.service

rm -f /etc/yum.repos.d/docker-ce.repo
