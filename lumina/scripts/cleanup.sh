#!/usr/bin/env bash

set -euox pipefail

# Replace all langpacks with just English to save ~230MB.
# allow_downgrade=0 forces dnf to pick the glibc-langpack-en matching the
# installed glibc (from updates) instead of an older one from updates-archive,
# which would otherwise downgrade glibc/glibc-common/glibc-gconv-extra.
dnf swap -y --setopt=allow_downgrade=0 glibc-all-langpacks glibc-langpack-en || true

dnf clean all
