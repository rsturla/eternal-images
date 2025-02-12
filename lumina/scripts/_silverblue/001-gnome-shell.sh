#!/usr/bin/env bash

set -euox pipefail

wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

dnf install -y \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-dash-to-dock \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-vertical-workspaces \
  gnome-shell-extension-caffeine \
  gnome-shell-extension-just-perfection \
  gnome-tweaks \
  libcanberra-gtk3

rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
