#!/usr/bin/env bash

set -euo pipefail

# Get the directory of the current script
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Add helpers directory to PATH for all scripts to use
export PATH="$SCRIPT_DIR/helpers:$PATH"

DESKTOP_ENVIRONMENT=$DESKTOP_ENVIRONMENT
MAJOR_VERSION=$MAJOR_VERSION

for script in "$SCRIPT_DIR"/_base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done

for script in "$SCRIPT_DIR"/_$DESKTOP_ENVIRONMENT/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done
