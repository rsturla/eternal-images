#!/usr/bin/bash

set -euox pipefail

cat << EOF > /etc/yum.repos.d/nordvpn.repo
[nordvpn]
name=NordVPN
baseurl=https://repo.nordvpn.com/yum/nordvpn/centos/\$basearch/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://repo.nordvpn.com/gpg/nordvpn_public.asc
EOF

dnf install -y nordvpn
systemctl enable nordvpnd

rm -f /etc/yum.repos.d/nordvpn.repo

echo "LOOKGING FOR ERRRO.LOG"
ls -la /
