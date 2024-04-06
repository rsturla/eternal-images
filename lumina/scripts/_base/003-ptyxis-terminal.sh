#!/usr/bin/env bash

set -euox pipefail

wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

rpm-ostree override replace \
  --experimental \
  --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
    gtk4 \
    vte291 \
    vte-profile \
    libadwaita

rpm-ostree install ptyxis
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/org.gnome.Terminal.desktop

rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
