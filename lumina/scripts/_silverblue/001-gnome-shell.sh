#!/usr/bin/env bash

set -euox pipefail

wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

rpm-ostree install \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-dash-to-dock \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-gsconnect \
  nautilus-gsconnect \
  yaru-theme \
  gnome-tweaks \
  libcanberra-gtk3 \
  nautilus-open-any-terminal

sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/org.gnome.Terminal.desktop

rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
