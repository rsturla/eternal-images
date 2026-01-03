#!/usr/bin/env bash

set -euox pipefail

# Create a custom authselect vendor profile with correct PAM ordering for systemd-homed.
# The default profile places pam_systemd_home.so after pam_unix.so, causing double
# password prompts for homed users. This profile fixes the module order.

PROFILE_NAME="homed"
PROFILE_DIR="/usr/share/authselect/vendor/${PROFILE_NAME}"

# Create vendor profile based on the local profile
mkdir -p "${PROFILE_DIR}"
cp -a /usr/share/authselect/default/local/* "${PROFILE_DIR}/"

# Fix PAM ordering in templates: move pam_systemd_home.so before pam_unix.so
# This ensures homed users authenticate with a single password prompt while
# regular users continue to work via pam_unix.so fallback
for pam_file in system-auth password-auth; do
  if [[ -f "${PROFILE_DIR}/${pam_file}" ]]; then
    sed -i \
      -e '/pam_systemd_home\.so/d' \
      -e '/^auth.*sufficient.*pam_unix\.so/i {include if "with-systemd-homed"}auth        sufficient                                   pam_systemd_home.so' \
      "${PROFILE_DIR}/${pam_file}"
  fi
done

# List profiles and show profile info for debugging
authselect list
ls -la "${PROFILE_DIR}/"
cat "${PROFILE_DIR}/REQUIREMENTS" || true

# Select using just the profile name (vendor profiles listed without prefix)
authselect select "${PROFILE_NAME}" with-systemd-homed --force

# Enable systemd-homed service
systemctl enable systemd-homed.service
