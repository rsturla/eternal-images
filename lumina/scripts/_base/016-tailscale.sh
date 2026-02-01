#!/usr/bin/env bash

set -euox pipefail

# Setup repo
cat << EOF > /etc/yum.repos.d/tailscale.repo
[tailscale-stable]
name=Tailscale stable
baseurl=https://pkgs.tailscale.com/stable/fedora/\$basearch
enabled=1
type=rpm
repo_gpgcheck=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-tailscale
EOF

# Import signing key
curl --retry 3 --retry-delay 2 --retry-all-errors -sL \
  -o /etc/pki/rpm-gpg/RPM-GPG-KEY-tailscale \
  https://pkgs.tailscale.com/stable/fedora/repo.gpg
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-tailscale

# Install tailscale and clipboard utilities for systray integration
dnf install -y \
  tailscale \
  wl-clipboard \
  xsel

# Enable the tailscaled service
systemctl enable tailscaled.service

# Enable the systray user service globally (starts on graphical login)
systemctl --global enable tailscale-systray.service

# Clean up the yum repo (updates come from new image builds)
rm -f /etc/yum.repos.d/tailscale.repo
