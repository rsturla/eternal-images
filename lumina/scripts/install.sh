#!/usr/bin/env bash

set -euo pipefail

DESKTOP=""
FEDORA_VERSION=""

# Read --desktop flag
while [[ $# -gt 0 ]]; do
  case "$1" in
    --desktop)
      DESKTOP="$2"
      shift 2
      ;;
    --version)
      FEDORA_VERSION="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$DESKTOP" ]]; then
  echo "--desktop flag is required"
  exit 1
fi

if [[ -z "$FEDORA_VERSION" ]]; then
  echo "--version flag is required"
  exit 1
fi

# Run base install scripts (run all files in /tmp/scripts/*.sh)
for script in /tmp/scripts/_base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "Running $script"
    bash "$script" --version "$FEDORA_VERSION"
  fi
done

# Run desktop install scripts (run all files in /tmp/scripts/$DESKTOP/*.sh)
for script in /tmp/scripts/_$DESKTOP/*.sh; do
  if [[ -f "$script" ]]; then
    echo "Running $script"
    bash "$script" --version "$FEDORA_VERSION"
  fi
done
