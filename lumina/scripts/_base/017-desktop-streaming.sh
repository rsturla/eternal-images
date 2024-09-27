#!/usr/bin/bash

set -euox pipefail

source /etc/os-release

FEDORA_VERSION=$VERSION_ID
curl -Lo /etc/yum.repos.d/matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-${FEDORA_VERSION}/matte-schwartz-sunshine-fedora-"${FEDORA_MAJOR_VERSION}".repo && \

rpm-ostree install sunshine
systemctl enable sunshine-workaround.service

rm -rf /etc/yum.repos.d/matte-schwartz-sunshine.repo
