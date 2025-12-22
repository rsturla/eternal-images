#!/usr/bin/bash

set -euox pipefail

# Install Brew dependencies
dnf install -y procps-ng curl file git gcc

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
systemctl enable brew-bundle.service

# Clean up
rm -rf /.dockerenv /var/home /var/roothome

# Create linuxbrew user/group via sysusers.d
cat >/usr/lib/sysusers.d/linuxbrew.conf <<EOF
u linuxbrew - "Homebrew" /var/home/linuxbrew /sbin/nologin
EOF

# Create directories via tmpfiles.d
cat >/usr/lib/tmpfiles.d/eternal-homebrew.conf <<EOF
d /var/lib/homebrew 0755 linuxbrew linuxbrew - -
d /var/cache/homebrew 0755 linuxbrew linuxbrew - -
d /var/home/linuxbrew 0755 linuxbrew linuxbrew - -
EOF
