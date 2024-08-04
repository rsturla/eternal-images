#!/usr/bin/env bash

set -euox pipefail

FEDORA_VERSION=$VERSION_ID

if [[ "$FEDORA_VERSION" == "39" ]]; then
  # Add the COPR repository
  wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo
fi

# Install the package
rpm-ostree install ptyxis

# Check if the Fedora version is 39
if [[ "$FEDORA_VERSION" == "39" ]]; then
  rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
fi
