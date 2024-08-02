#!/usr/bin/bash

set -euox pipefail

cat << EOF > /etc/yum.repos.d/nordvpn.repo
[nordvpn]
name=NordVPN
baseurl=https://repo.nordvpn.com/yum/nordvpn/centos/\$basearch/
enabled=1
gpgcheck=0
EOF

rpm-ostree install nordvpn

rm -f /etc/yum.repos.d/nordvpn.repo
