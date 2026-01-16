#!/usr/bin/env bash

set -euox pipefail

dnf install -y \
    krb5-workstation \
    beaker-client \
    conserver-client \
    tmt

curl -Lo /usr/bin/testing-farm "https://gitlab.com/testing-farm/cli/-/raw/main/container/testing-farm"
chmod +x /usr/bin/testing-farm
