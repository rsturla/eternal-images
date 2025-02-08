#!/usr/bin/env sh

set -ouex pipefail

# Prepare staging directory
mkdir -p /var/opt

# Setup repo
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-google
EOF

# Prepare alternatives directory
mkdir -p /var/lib/alternatives

# Import signing key
curl --retry 3 --retry-delay 2 --retry-all-errors -sL \
  -o /etc/pki/rpm-gpg/RPM-GPG-KEY-google \
  https://dl.google.com/linux/linux_signing_key.pub
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-google

# Install the packages
dnf install -y google-chrome-stable

# Clean up the yum repo
rm -f /etc/yum.repos.d/google-chrome.repo

# Move the application to somewhere on the final image
mv /var/opt/google /usr/lib/google

# Register path symlink
cat >/usr/lib/tmpfiles.d/eternal-google.conf <<EOF
L  /opt/google  -  -  -  -  /usr/lib/google
EOF

# Workaround to remove Google Chrome profile locks
cat >/usr/share/user-tmpfiles.d/eternal-google-locks.conf <<EOF
r  %h/.config/google-chrome/Singleton*  -  -  -  -  -
EOF
