#!/usr/bin/env bash

set -euox pipefail

dnf copr enable -y ublue-os/staging

dnf install -y \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-dash-to-dock \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-vertical-workspaces \
  gnome-shell-extension-caffeine \
  gnome-shell-extension-just-perfection \
  gnome-tweaks \
  libcanberra-gtk3

dnf remove -y gnome-software

dnf copr remove -y ublue-os/staging
