#!/usr/bin/env bash

set -euox pipefail

dnf copr enable rhcontainerbot/bootc
dnf install -y bootc
