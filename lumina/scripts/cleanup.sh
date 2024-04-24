#!/usr/bin/env bash

set -euox pipefail

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/rpmfusion-{free,nonfree}{,-updates,-updates-testing}.repo

# Test Quadlets
/usr/lib/systemd/system-generators/podman-system-generator {,--user} --dryrun
