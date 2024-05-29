#!/usr/bin/bash

set -euox pipefail

# Setup repo
cat << EOF > /etc/yum.repos.d/twingate.repo
[twingate]
name=Twingate
baseurl=https://packages.twingate.com/rpm/
enabled=1
gpgcheck=0
EOF

rpm-ostree install twingate

rm /etc/yum.repos.d/twingate.repo
