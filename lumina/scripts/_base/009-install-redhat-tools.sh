#!/usr/bin/env bash

set -euox pipefail

dnf install -y \
    krb5-workstation \
    beaker-client \
    conserver-client
