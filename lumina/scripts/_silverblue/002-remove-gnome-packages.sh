#!/usr/bin/env bash

set -euox pipefail

dnf remove -y \
  gnome-tour \
  gnome-extensions-app \
  gnome-system-monitor \
  yelp
