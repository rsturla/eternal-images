#!/usr/bin/env bash

set -euox pipefail

dnf install -y \
  libvirt \
  virt-manager \
  edk2-ovmf

systemctl enable swtpm-workaround.service

# Register path symlink
# We do this via tmpfiles.d so that it is created by the live system.
cat >/usr/lib/tmpfiles.d/eternal-libvirt.conf <<EOF
d /var/lib/pcp/config/pmda 0775 pcp pcp -
d /var/lib/pcp/config/pmie 0775 pcp pcp -
d /var/lib/pcp/config/pmlogger 0775 pcp pcp -
d /var/lib/pcp/tmp 0775 pcp pcp -
d /var/lib/pcp/tmp/bash 0775 pcp pcp -
d /var/lib/pcp/tmp/json 0775 pcp pcp -
d /var/lib/pcp/tmp/mmv 0775 pcp pcp -
d /var/lib/pcp/tmp/pmie 0775 pcp pcp -
d /var/lib/pcp/tmp/pmlogger 0775 pcp pcp -
d /var/lib/pcp/tmp/pmproxy 0775 pcp pcp -
d /var/log/pcp 0775 pcp pcp -
d /var/log/pcp/pmcd 0775 pcp pcp -
d /var/log/pcp/pmfind 0775 pcp pcp -
d /var/log/pcp/pmie 0775 pcp pcp -
d /var/log/pcp/pmlogger 0775 pcp pcp -
d /var/log/pcp/pmproxy 0775 pcp pcp -
d /var/log/pcp/sa 0775 pcp pcp -

C /usr/local/bin/.swtpm - - - - /usr/bin/swtpm
d /var/lib/swtpm-localca 0750 tss tss - -
EOF
