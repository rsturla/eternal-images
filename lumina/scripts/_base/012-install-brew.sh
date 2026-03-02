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
systemctl enable brew-update.timer
systemctl enable brew-upgrade.timer
systemctl enable brew-cleanup.timer
systemctl enable brew-bundle.service

# Clean up
# Only remove linuxbrew files (now tarred), preserve /var/home and /var/roothome
# to maintain their SELinux labels from the base image
rm -rf /.dockerenv /var/home/linuxbrew

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

# Set SELinux file context for homebrew directory (persistent, survives restorecon)
# This allows systemd services (init_t) to access homebrew binaries
semanage fcontext -a -t usr_t "/var/home/linuxbrew/.linuxbrew(/.*)?"

# Chunkah: group all non-RPM homebrew files so they get their own layer
setfattr -n user.component -v "lumina-brew" /usr/libexec/brew-wrapper /usr/bin/brewsu
setfattr -n user.component -v "lumina-brew" /usr/share/homebrew.tar.zst /usr/share/brew
find /usr/share/brew -mindepth 1 -exec setfattr -n user.component -v "lumina-brew" {} \;
