#!/usr/bin/env bash

set -ouex pipefail

# Extract the architecture from the kernel package
arch=$(rpm -q kernel --qf "%{ARCH}\n" | head -n1)

# Check if the architecture is aarch64
if [[ "$arch" == "aarch64" ]]; then
    echo "1Password does not create aarch64 packages"
    exit 0
fi

# Thanks to bri for the inspiration! My script is mostly based on this example:
# https://github.com/briorg/bluefin/blob/c62c30a04d42fd959ea770722c6b51216b4ec45b/scripts/1password.sh

echo "Installing 1Password"

# On libostree systems, /opt is a symlink to /var/opt,
# which actually only exists on the live system. /var is
# a separate mutable, stateful FS that's overlaid onto
# the ostree rootfs. Therefore we need to install it into
# /usr/lib/1Password instead, and dynamically create a
# symbolic link /opt/1Password => /usr/lib/1Password upon
# boot.

# Prepare staging directory
mkdir -p /var/opt # -p just in case it exists
# for some reason...

# Setup repo
cat << EOF > /etc/yum.repos.d/1password.repo
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

# Import signing key
#rpm --import https://downloads.1password.com/linux/keys/1password.asc

# Now let's install the packages.
dnf install -y 1password 1password-cli

# Clean up the yum repo (updates are baked into new images)
rm /etc/yum.repos.d/1password.repo -f

# And then we do the hacky dance!
mv /var/opt/1Password /usr/lib/1Password # move this over here

# Create a symlink /usr/bin/1password => /opt/1Password/1password
rm /usr/bin/1password
ln -s /opt/1Password/1password /usr/bin/1password

#####
# The following is a bastardization of "after-install.sh"
# which is normally packaged with 1password. You can compare with
# /usr/lib/1Password/after-install.sh if you want to see.

# chrome-sandbox requires the setuid bit to be specifically set.
# See https://github.com/electron/electron/issues/17972
chmod 4755 /usr/lib/1Password/chrome-sandbox

# Normally, after-install.sh would create a group,
# "onepassword", right about now. But if we do that during
# the ostree build it'll disappear from the running system!
# I'm going to work around that by hardcoding GIDs and
# crossing my fingers that nothing else steps on them.
# These numbers _should_ be okay under normal use, but
# if there's a more specific range that I should use here
# please submit a PR!

# Specifically, GID must be > 1000, and absolutely must not
# conflict with any real groups on the deployed system.
# Normal user group GIDs on Fedora are sequential starting
# at 1000, so let's skip ahead and set to something higher.
GID_ONEPASSWORD="1790"
GID_ONEPASSWORDCLI="1791"

BROWSER_SUPPORT_PATH="/usr/lib/1Password/1Password-BrowserSupport"

# BrowserSupport binary needs setgid. This gives no extra permissions to the binary.
# It only hardens it against environmental tampering.
chgrp "${GID_ONEPASSWORD}" "${BROWSER_SUPPORT_PATH}"
chmod g+s "${BROWSER_SUPPORT_PATH}"

# onepassword-cli also needs its own group and setgid, like the other helpers.
chgrp ${GID_ONEPASSWORDCLI} /usr/bin/op
chmod g+s /usr/bin/op

# Dynamically create the required groups via sysusers.d
# and set the GID based on the files we just chgrp'd
cat >/usr/lib/sysusers.d/onepassword.conf <<EOF
g onepassword ${GID_ONEPASSWORD}
EOF
cat >/usr/lib/sysusers.d/onepassword-cli.conf <<EOF
g onepassword-cli ${GID_ONEPASSWORDCLI}
EOF

# remove the sysusers.d entries created by onepassword RPMs.
# They don't magically set the GID like we need them to.
rm -f /usr/lib/sysusers.d/30-rpmostree-pkg-group-onepassword.conf
rm -f /usr/lib/sysusers.d/30-rpmostree-pkg-group-onepassword-cli.conf

# Register path symlink
# We do this via tmpfiles.d so that it is created by the live system.
cat >/usr/lib/tmpfiles.d/eternal-onepassword.conf <<EOF
L  /opt/1Password  -  -  -  -  /usr/lib/1Password
EOF
