#!/usr/bin/env bash

set -euox pipefail

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/rpmfusion-{free,nonfree}{,-updates,-updates-testing}.repo
