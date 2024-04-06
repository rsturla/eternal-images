#!/usr/bin/env bash

set -euox pipefail

systemctl unmask dconf-update.service
systemctl enable dconf-update.service
