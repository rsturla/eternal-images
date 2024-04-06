#!/usr/bin/env bash

set -euox pipefail

curl -Lo /tmp/kind "https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-$(uname)-amd64"
install -c -m 0755 /tmp/kind /usr/bin/kind

rpm-ostree install $(curl https://api.github.com/repos/wagoodman/dive/releases/latest | jq -r '.assets[] | select(.name| test(".*_linux_amd64.rpm$")).browser_download_url')

curl -Lo /tmp/vcluster "https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64"
install -c -m 0755 /tmp/vcluster /usr/bin/vcluster

curl -Lo /tmp/devbox https://releases.jetpack.io/devbox
install -c -m 0755 /tmp/devbox /usr/bin/devbox

rpm-ostree install \
  gh \
  neovim

rm -f /etc/yum.repos.d/github.repo
