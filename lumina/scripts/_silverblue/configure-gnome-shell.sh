#!/usr/bin/env bash

set -euo pipefail

rpm-ostree install \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-dash-to-dock \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-gsconnect \
  nautilus-gsconnect \
  yaru-theme \
  gnome-tweaks \
  libcanberra-gtk3
