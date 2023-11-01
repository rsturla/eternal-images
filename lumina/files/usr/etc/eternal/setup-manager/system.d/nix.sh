#!/usr/bin/env bash

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

if [ ! -f /etc/bashrc.d/devbox.sh ]; then
  echo 'eval "$(devbox global shellenv --init-hook)"' >> /etc/bashrc.d/devbox.sh
  chmod +x /etc/bashrc.d/devbox.sh
fi
