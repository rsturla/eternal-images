#!/usr/bin/env bash
set -euo pipefail

BASE_IMAGE=silverblue
SOURCE_IMAGE=ghcr.io/rsturla/eternal-linux/main/${BASE_IMAGE}
MAJOR_VERSION=42
# Accept desktop environment as argument, default to 'gnome' if not provided
DESKTOP_ENVIRONMENT="${1:-gnome}"

OUTPUT="Containerfile.gen"

echo "Generating $OUTPUT for desktop environment: $DESKTOP_ENVIRONMENT"

# Start fresh
cat > "$OUTPUT" <<EOF
# syntax=docker/dockerfile:1.4
ARG BASE_IMAGE=${BASE_IMAGE}
ARG MAJOR_VERSION=${MAJOR_VERSION}
ARG DESKTOP_ENVIRONMENT=${DESKTOP_ENVIRONMENT}
ARG SOURCE_IMAGE=${SOURCE_IMAGE}

FROM ${SOURCE_IMAGE}:${MAJOR_VERSION}

ARG MAJOR_VERSION
ARG DESKTOP_ENVIRONMENT

COPY files/_base/ /
COPY files/_${DESKTOP_ENVIRONMENT}* /

EOF

echo "COPY --chmod=755 scripts/helpers/* /scripts/helpers/" >> "$OUTPUT"
echo "ENV PATH=\"/scripts/helpers/:\$PATH\"" >> "$OUTPUT"

# Add base scripts
for script in scripts/_base/*.sh; do
  filename=$(basename "$script")
  echo "COPY --chmod=755 scripts/_base/${filename} /scripts/${filename}" >> "$OUTPUT"
  echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/tmp \\" >> "$OUTPUT"
  echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
  echo "    --mount=type=secret,id=GITHUB_TOKEN \\" >> "$OUTPUT"
  echo "    /bin/bash /scripts/${filename}" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

# Add desktop environment scripts, if not base
if [[ "$DESKTOP_ENVIRONMENT" != "base" ]]; then
  for script in scripts/_${DESKTOP_ENVIRONMENT}/*.sh; do
    filename=$(basename "$script")
    echo "COPY --chmod=755 scripts/_${DESKTOP_ENVIRONMENT}/${filename} /scripts/${filename}" >> "$OUTPUT"
    echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/tmp \\" >> "$OUTPUT"
    echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
    echo "    --mount=type=secret,id=GITHUB_TOKEN \\" >> "$OUTPUT"
    echo "    /bin/bash /scripts/${filename}" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
  done
fi

# Add cleanup script
echo "COPY --chmod=755 scripts/cleanup.sh /scripts/cleanup.sh" >> "$OUTPUT"
echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/tmp \\" >> "$OUTPUT"
echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
echo "    --mount=type=secret,id=GITHUB_TOKEN \\" >> "$OUTPUT"
echo "    /bin/bash /scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT}" >> "$OUTPUT"

echo ""
echo "✅ $OUTPUT generated."
