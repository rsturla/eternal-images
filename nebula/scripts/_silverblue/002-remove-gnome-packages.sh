#!/usr/bin/env bash

set -euox pipefail

rpm-ostree override remove \
  gnome-tour \
  gnome-extensions-app \
  gnome-system-monitor \
  gnome-terminal-nautilus \
  yelp
