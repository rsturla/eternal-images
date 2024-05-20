#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
	cockpit-machines \
	cockpit-networkmanager \
	cockpit-ostree \
	cockpit-pcp \
	cockpit-podman \
	cockpit-selinux \
	cockpit-storaged \
	cockpit-system
