#!/usr/bin/env bash

set -euox pipefail

wget https://copr.fedorainfracloud.org/coprs/dsommers/openvpn3-devsnapshots/repo/fedora-$(rpm -E %fedora)/dsommers-openvpn3-devsnapshots-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_dsommers-devsnapshots.repo

rpm-ostree install openvpn3

rm -rf /etc/yum.repos.d/_copr_dsommers-devsnapshots.repo
