#!/usr/bin/env bash

set -euox pipefail
source /etc/os-release

FEDORA_VERSION=$VERSION_ID

wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

# Fedora 40 already has the required versions of gtk4 and libadwaita
if [[ "$FEDORA_VERSION" == "39" ]]; then
  rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
      gtk4 \
      libadwaita
fi

rpm-ostree install ptyxis

rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
