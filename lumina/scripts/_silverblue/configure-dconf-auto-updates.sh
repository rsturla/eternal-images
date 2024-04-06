#!/usr/bin/env bash

set -euo pipefail

systemctl unmask dconf-update.service
systemctl enable dconf-update.service
