#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
    crun-vm \
    amazon-ecr-credential-helper
