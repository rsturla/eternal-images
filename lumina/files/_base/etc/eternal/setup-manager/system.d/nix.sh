#!/usr/bin/env bash

set -euo pipefail

curl --proto '=https' --retry 3 --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ostree --no-confirm --determinate

tee /etc/sudoers.d/nix-sudo-env <<EOF
    Defaults  secure_path = /nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$(printenv PATH)
EOF
