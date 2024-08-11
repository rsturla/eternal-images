#!/usr/bin/bash

set -euox pipefail

RELEASE_URL="https://github.com/firecracker-microvm/firecracker/releases"
LATEST_VERSION=$(basename $(curl -fsSLI -o /dev/null -w %{url_effective} ${RELEASE_URL}/latest))

curl -L ${RELEASE_URL}/download/${LATEST_VERSION}/firecracker-${LATEST_VERSION}-$(uname -m).tgz | tar -xz -C /tmp

install -c -m 0755 /tmp/release-${LATEST_VERSION}-$(uname -m)/firecracker-${LATEST_VERSION}-$(uname -m) /usr/bin/firecracker
install -c -m 0755 /tmp/release-${LATEST_VERSION}-$(uname -m)/jailer-${LATEST_VERSION}-$(uname -m) /usr/bin/jailer


curl -Lo /tmp/cni-plugins.tgz $(curl https://api.github.com/repos/containernetworking/plugins/releases/latest | jq -r '.assets[] | select(.name| test("cni-plugins-linux-amd64-v.*.tgz$")).browser_download_url')
mkdir -p /tmp/cni-plugins
tar -xzf /tmp/cni-plugins.tgz -C /tmp/cni-plugins
mkdir -p /usr/cni/bin
mv /tmp/cni-plugins/* /usr/cni/bin
