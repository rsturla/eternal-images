#!/usr/bin/env bash

set -euox pipefail

FEDORA_VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      FEDORA_VERSION="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$FEDORA_VERSION" ]]; then
  echo "--version flag is required"
  exit 1
fi

wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

rpm-ostree override replace \
  --experimental \
  --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
    vte291 \
    vte-profile

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
