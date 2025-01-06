#!/usr/bin/env bash

set -euox pipefail
source /etc/os-release

BASE=""
FEDORA_VERSION=$VERSION_ID

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      BASE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$BASE" ]]; then
  echo "--base flag is required"
  exit 1
fi

for script in /tmp/scripts/_base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group:: ===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done

for script in /tmp/scripts/_$BASE/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group:: ===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done
