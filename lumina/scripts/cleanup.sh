#!/usr/bin/env bash

set -euox pipefail

# Replace all langpacks with just English to save ~230MB
dnf swap -y glibc-all-langpacks glibc-langpack-en || true

dnf clean all
