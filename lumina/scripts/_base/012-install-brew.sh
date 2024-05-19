#!/usr/bin/bash

set -euox pipefail

# Install Brew dependencies
# Install "Development Tools" group
rpm-ostree install \
  buildbot colordiff cvs cvs2cl cvsps darcs dejagnu diffstat doxygen expect \
  gambas3-ide gettext git git-annex git-cola git2cl gitg gtranslator highlight lcov \
  manedit meld monotone myrepos nemiver patch patchutils qgit quilt rapidsvn rcs robodoc \
  scanmem subunit subversion svn2cl systemtap tig tortoisehg translate-toolkit utrac \

rpm-ostree install procps-ng curl file git

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
