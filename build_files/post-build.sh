#!/bin/bash

set -ouex pipefail

# Write the DE identifier so rakuos-overlay-mount can detect a DE change at
# boot and trigger a soft reset to rebuild the overlay from packages.list.
echo "hyprland" > /usr/share/rakuos/de-name

# Custom os-release for RakuOS Hyprland
BUILD_DATE=$(date -u +%Y%m%d)
BUILD_VERSION=$(date -u +%Y.%m.%d)

cat > /usr/lib/os-release << EOF
NAME="RakuOS Hyprland"
VERSION="${BUILD_VERSION} (${BUILD_DATE})"
ID="rakuos"
ID_LIKE="fedora"
VERSION_ID="44"
PLATFORM_ID="platform:f44"
PRETTY_NAME="RakuOS Hyprland x86_64 (${BUILD_DATE})"
ANSI_COLOR="1;34"
HOME_URL="https://rakuos.org"
BUG_REPORT_URL="https://github.com/tofan79/RakuOs-Hyprland/issues"
EOF
