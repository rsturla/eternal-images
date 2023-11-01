#!/usr/bin/env bash

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
echo 'eval "$(devbox global shellenv --init-hook)"' >> /etc/bashrc.d/devbox.sh
