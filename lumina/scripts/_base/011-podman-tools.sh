#!/usr/bin/env bash

set -euox pipefail

dnf install -y \
    crun-vm \
    podman-machine
