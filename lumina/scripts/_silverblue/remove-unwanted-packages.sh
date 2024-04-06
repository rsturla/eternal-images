#!/usr/bin/env bash

set -euo pipefail

rpm-ostree override remove \
  gnome-tour \
  gnome-extensions-app \
  gnome-system-monitor \
  yelp
