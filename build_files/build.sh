#!/bin/bash

set -ouex pipefail

FEDORA_VERSION=$(rpm -E %fedora)

# On the staging branch (RAKUOS_STAGING=1, set via --build-arg from CI)
# install the staging os-release identity instead of the stable one, so
# staging images identify themselves as "RakuOS Hyprland Staging".
RAKUOS_RELEASE_PKG="rakuos-release"
if [ "${RAKUOS_STAGING:-0}" = "1" ]; then
    RAKUOS_RELEASE_PKG="rakuos-release-staging"
fi

## Enable COPR repos
echo "Enabling COPR repos..."
dnf5 -y copr enable lionheartp/Hyprland 2>/dev/null || echo "Warning: Failed to enable Hyprland COPR"
dnf5 -y copr enable mindset/Mindset-Apps 2>/dev/null || echo "Warning: Failed to enable Mindset-Apps COPR"

# Set COPR priority to 20 (below RakuOS v3=10, above default=99)
for repo_file in /etc/yum.repos.d/_copr_lionheartp-Hyprland.repo /etc/yum.repos.d/_copr_lionheartp-Hyprland-*.repo; do
    [[ -f "$repo_file" ]] && sed -i 's/^priority=.*/priority=20/' "$repo_file"
done

for repo_file in /etc/yum.repos.d/_copr_mindset-Mindset-Apps.repo /etc/yum.repos.d/_copr_mindset-Mindset-Apps-*.repo; do
    [[ -f "$repo_file" ]] && sed -i 's/^priority=.*/priority=20/' "$repo_file"
done

## Install packages — Pure Hyprland edition
rum install -y \
  # Hyprland core
  hyprland \
  cliphist \
  xdg-desktop-portal-hyprland \
  xwayland-satellite \
  # Display manager
  sddm \
  sddm-kcm \
  # Screenshot & OCR
  grim \
  slurp \
  satty \
  tesseract \
  tesseract-data-eng \
  zbar \
  # Gaming
  switcherooctl \
  switcheroo-control \
  gamemode \
  mangohud \
  # Dev tools
  @development-tools \
  cmake \
  meson \
  ninja-build \
  # CLI essentials
  fd-find \
  tree \
  bc \
  lsof \
  hwinfo \
  smartmontools \
  wget2 \
  eza \
  dua-cli \
  # Hardware & power
  brightnessctl \
  ddcutil \
  power-profiles-daemon \
  # Media
  playerctl \
  pamixer \
  alsa-utils \
  gstreamer1-plugins-base \
  gstreamer1-plugins-good \
  gstreamer1-plugins-bad-free \
  gstreamer1-plugins-ugly-free \
  gstreamer1-plugin-libav \
  x264 \
  x265 \
  # Display & theming
  wlsunset \
  qt5ct \
  qt6ct \
  qt6-wayland \
  papirus-icon-theme \
  tela-icon-theme \
  # File system
  exfatprogs \
  ntfs-3g \
  btrfs-progs \
  cifs-utils \
  dosfstools \
  # Fonts
  jetbrains-mono-fonts \
  google-noto-color-emoji-fonts \
  adobe-source-code-pro-fonts \
  # System
  dbus-tools \
  logrotate \
  gnome-keyring \
  networkmanager-openvpn \
  zram-generator-defaults \
  # Network (required)
  NetworkManager-adsl \
  NetworkManager-bluetooth \
  NetworkManager-ppp \
  NetworkManager-wwan \
  # Terminal
  ghostty \
  ghostty-nautilus \
  # File manager
  nautilus \
  # RakuOS
  ${RAKUOS_RELEASE_PKG} \
  rakuos-software-gtk \
  rakuos-welcome-gtk \
  systemd-oomd-defaults \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk \
  xdg-user-dirs-gtk

## Remove fedora wallpapers
rm -r /usr/share/backgrounds/fedora-workstation/

## Unlock keyring on login
sed -i -E 's/^-([a-z]+[[:space:]]+.*pam_gnome_keyring\.so)/\1/' /etc/pam.d/sddm

## Enable Services
systemctl enable sddm
systemctl enable bluetooth
systemctl enable switcheroo-control
systemctl enable tuned
