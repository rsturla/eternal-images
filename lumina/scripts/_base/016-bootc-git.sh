#!/usr/bin/env bash

set -euox pipefail

dnf copr enable -y rhcontainerbot/bootc
dnf -y swap \
    --repo=copr:copr.fedorainfracloud.org:rhcontainerbot:bootc \
    bootc bootc

dnf copr remove -y rhcontainerbot/bootc
