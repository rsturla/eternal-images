#!/usr/bin/env bash

# Copy /etc/eternal/config/atuin.toml to $HOME/.config/atuin/config.toml if it doesn't exist
if [ ! -f $HOME/.config/atuin/config.toml ]; then
  echo "Copying /etc/eternal/config/atuin.toml to $HOME/.config/atuin/config.toml as it doesn't exist"
  mkdir -p $HOME/.config/atuin
  cp /etc/eternal/config/atuin.toml $HOME/.config/atuin/config.toml
  exit 0
fi

echo "Skipping copying /etc/eternal/config/atuin.toml to $HOME/.config/atuin/config.toml as it already exists"
