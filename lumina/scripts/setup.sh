#!/usr/bin/env bash

set -euo pipefail

DESKTOP_ENVIRONMENT=$DESKTOP_ENVIRONMENT
MAJOR_VERSION=$MAJOR_VERSION

for script in /tmp/scripts/_base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done

for script in /tmp/scripts/_$DESKTOP_ENVIRONMENT/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done
