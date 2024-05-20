#!/usr/bin/bash

set -euox pipefail

# Install Brew dependencies
rpm-ostree install procps-ng curl file git gcc

# Convince the installer we are in CI
touch /.dockerenv

# Make these so script will work
mkdir -p /var/home
mkdir -p /var/roothome

# Brew Install Script
curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x /tmp/brew-install
/tmp/brew-install
tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew

# Enable Systemd services
systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer

# Clean up
rm -rf /.dockerenv /var/home /var/roothome
