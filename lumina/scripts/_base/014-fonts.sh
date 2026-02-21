#!/usr/bin/env bash
set -euox pipefail

# List of packages to download
PACKAGES=(
    "monaspace-frozen"
    "monaspace-static"
    "monaspace-variable"
    # "monaspace-nerdfonts"
    # "monaspace-webfont-nerdfonts"
    # "monaspace-webfont-static"
    # "monaspace-webfont-variable"
)

# Temporary directory for downloads
TMP_DIR="/tmp/monaspace-font"
mkdir -p "$TMP_DIR"

# Target font directory
FONT_DIR="/usr/share/fonts/monaspace"
mkdir -p "$FONT_DIR"

# Function to get the latest download URL for a package
get_download_url() {
    local pkg="$1"
    ghcurl "https://api.github.com/repos/githubnext/monaspace/releases/latest" \
        | jq -r --arg pkg "$pkg" '.assets[] | select(.name | contains($pkg) and endswith(".zip")) | .browser_download_url'
}

# Download and install selected packages
for pkg in "${PACKAGES[@]}"; do
    echo "Downloading $pkg..."
    DOWNLOAD_URL=$(get_download_url "$pkg")
    ZIP_FILE="$TMP_DIR/${pkg}.zip"
    ghcurl "$DOWNLOAD_URL" -o "$ZIP_FILE"

    echo "Unpacking $pkg..."
    unzip -qo "$ZIP_FILE" -d "$TMP_DIR/$pkg"

    # Move OTF and TTF fonts into the font directory
    find "$TMP_DIR/$pkg" -type f \( -name "*.otf" -o -name "*.ttf" \) -exec mv {} "$FONT_DIR/" \;
done

# Refresh font cache
fc-cache -f "$FONT_DIR"

# Chunkah: group Monaspace fonts (non-RPM) so they get their own layer
setfattr -n user.component -v "lumina-fonts" "$FONT_DIR"
find "$FONT_DIR" -mindepth 1 -exec setfattr -n user.component -v "lumina-fonts" {} \;

echo "Monaspace fonts installed successfully!"
