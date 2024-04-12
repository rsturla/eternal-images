#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install code

rm -f /etc/yum.repos.d/vscode.repo
