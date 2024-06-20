#!/usr/bin/bash

set -euox pipefail

wget https://copr.fedorainfracloud.org/coprs/dsommers/openvpn3/repo/fedora-$(rpm -E %fedora)/dsommers-openvpn3-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/openvpn3.repo

rpm-ostree install \
    openvpn3-client

rm /etc/yum.repos.d/openvpn3.repo
