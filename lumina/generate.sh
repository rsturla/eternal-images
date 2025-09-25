#!/usr/bin/env bash
set -euo pipefail

# Allow overrides from environment variables, but provide defaults
BASE_IMAGE="${BASE_IMAGE:-silverblue}"
SOURCE_IMAGE="${SOURCE_IMAGE:-ghcr.io/rsturla/eternal-linux/main/${BASE_IMAGE}}"
MAJOR_VERSION="${MAJOR_VERSION:-42}"
DESKTOP_ENVIRONMENT="${DESKTOP_ENVIRONMENT:-gnome}"

OUTPUT="Containerfile.gen"

echo "Generating $OUTPUT for desktop environment: $DESKTOP_ENVIRONMENT"

# Start fresh
cat > "$OUTPUT" <<EOF
# syntax=docker/dockerfile:1.4
ARG BASE_IMAGE=${BASE_IMAGE}
ARG MAJOR_VERSION=${MAJOR_VERSION}
ARG DESKTOP_ENVIRONMENT=${DESKTOP_ENVIRONMENT}
ARG SOURCE_IMAGE=${SOURCE_IMAGE}

FROM scratch AS ctx

COPY ./scripts /scripts
COPY ./files /files


FROM \${SOURCE_IMAGE}:\${MAJOR_VERSION}

ARG MAJOR_VERSION
ARG DESKTOP_ENVIRONMENT

COPY --from=ctx files/_base/ /
COPY --from=ctx files/_${DESKTOP_ENVIRONMENT}* /

EOF

# echo "COPY --from=ctx --chmod=755 /scripts/helpers/* /buildcontext/scripts/helpers/" >> "$OUTPUT"
echo "ENV PATH=\"/buildcontext/scripts/helpers/:\$PATH\"" >> "$OUTPUT"

# Add base scripts
for script in scripts/_base/*.sh; do
  filename=$(basename "$script")
  echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/tmp \\" >> "$OUTPUT"
  echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
  echo "    --mount=type=bind,from=ctx,src=/scripts/_base,dst=/buildcontext/scripts/ \\" >> "$OUTPUT"
  echo "    --mount=type=bind,from=ctx,src=/scripts/helpers,dst=/buildcontext/scripts/helpers/ \\" >> "$OUTPUT"
  echo "    --mount=type=secret,id=GITHUB_TOKEN \\" >> "$OUTPUT"
  echo "    /bin/bash /buildcontext/scripts/${filename}" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

# Add desktop environment scripts, if not base
if [[ "$DESKTOP_ENVIRONMENT" != "base" ]]; then
  for script in scripts/_${DESKTOP_ENVIRONMENT}/*.sh; do
    filename=$(basename "$script")
    echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/tmp \\" >> "$OUTPUT"
    echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
    echo "    --mount=type=bind,from=ctx,src=/scripts/_\${DESKTOP_ENVIRONMENT},dst=/buildcontext/scripts/ \\" >> "$OUTPUT"
    echo "    --mount=type=bind,from=ctx,src=/scripts/helpers,dst=/buildcontext/scripts/helpers/ \\" >> "$OUTPUT"
    echo "    --mount=type=secret,id=GITHUB_TOKEN \\" >> "$OUTPUT"
    echo "    /bin/bash /buildcontext/scripts/${filename}" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
  done
fi

# Add cleanup script
echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/tmp \\" >> "$OUTPUT"
echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
echo "    --mount=type=bind,from=ctx,src=/scripts/cleanup.sh,dst=/buildcontext/scripts/cleanup.sh \\" >> "$OUTPUT"
echo "    --mount=type=bind,from=ctx,src=/scripts/helpers,dst=/buildcontext/scripts/helpers/ \\" >> "$OUTPUT"
echo "    --mount=type=secret,id=GITHUB_TOKEN \\" >> "$OUTPUT"
echo "    /bin/bash /buildcontext/scripts/cleanup.sh --base \${DESKTOP_ENVIRONMENT}" >> "$OUTPUT"

# Add final lint checks
echo "RUN bootc container lint --no-truncate" >> "$OUTPUT"

echo ""
echo "✅ $OUTPUT generated."
