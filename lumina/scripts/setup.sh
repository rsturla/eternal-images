#!/usr/bin/env bash

set -euo pipefail

BASE_IMAGE=$BASE_IMAGE
FEDORA_VERSION=$FEDORA_VERSION

for script in /tmp/scripts/_base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done

for script in /tmp/scripts/_$BASE_IMAGE/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done
