#!/usr/bin/env bash

set -euox pipefail

# Test Quadlets
QUADLET_UNIT_DIRS=/usr/etc/containers/systemd /usr/lib/systemd/system-generators/podman-system-generator --dryrun
QUADLET_UNIT_DIRS=/usr/etc/containers/systemd/users /usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
