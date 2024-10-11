#!/usr/bin/env bash

set -euox pipefail
source /etc/os-release

FEDORA_VERSION=$VERSION_ID

wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

rpm-ostree install \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-dash-to-dock \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-search-light \
  gnome-shell-extension-caffeine \
  gnome-shell-extension-just-perfection \
  gnome-tweaks \
  libcanberra-gtk3 \
  nautilus-open-any-terminal

if [[ "$FEDORA_VERSION" == "40" ]]; then
  sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/org.gnome.Terminal.desktop
fi

rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
