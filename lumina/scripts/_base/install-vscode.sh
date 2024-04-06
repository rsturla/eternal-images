#!/usr/bin/env bash

set -euo pipefail

rpm-ostree install code

rm -f /etc/yum.repos.d/vscode.repo
