#!/usr/bin/env bash

set -euo pipefail

# Add helpers directory to PATH for all scripts to use
export PATH="/tmp/scripts/helpers:$PATH"

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
