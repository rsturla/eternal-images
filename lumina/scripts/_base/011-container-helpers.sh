#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
    crun-vm 

# Download ECR Credential Helper
ARCH=$(uname -m)
[ "$ARCH" = "arm" ] && ARCH="arm64"

TAG_NAME=$(curl -s https://api.github.com/repos/awslabs/amazon-ecr-credential-helper/releases/latest | jq -r ".tag_name" | cut -c 2-)

curl -Lo /usr/bin/docker-credential-ecr-login https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${TAG_NAME}/linux-${ARCH}/docker-credential-ecr-login
chmod +x /usr/bin/docker-credential-ecr-login
