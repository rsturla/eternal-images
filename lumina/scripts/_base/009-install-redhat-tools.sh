#!/usr/bin/env bash

set -euox pipefail

cat << EOF > /etc/yum.repos.d/netbird.repo
[NetBird]
name=NetBird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
EOF

dnf install -y \
    krb5-workstation \
    beaker-client \
    conserver-client \
    tmt

dnf install -y --setopt=tsflags=noscripts \
    netbird \
    netbird-ui

curl -Lo /usr/bin/testing-farm "https://gitlab.com/testing-farm/cli/-/raw/main/container/testing-farm"
chmod +x /usr/bin/testing-farm

rm -f /etc/yum.repos.d/netbird.repo
