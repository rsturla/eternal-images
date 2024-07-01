#!/usr/bin/env bash

set -euo pipefail

# Test Quadlets
# To avoid incredibly long outputs, we redirect the output to /dev/null and log only errors
QUADLET_UNIT_DIRS=/usr/etc/containers/systemd /usr/lib/systemd/system-generators/podman-system-generator --dryrun > /dev/null 2>>error.log
QUADLET_UNIT_DIRS=/usr/etc/containers/systemd/users /usr/lib/systemd/system-generators/podman-system-generator --user --dryrun > /dev/null 2>>error.log
