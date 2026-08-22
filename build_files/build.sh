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
  hyprland cliphist xdg-desktop-portal-hyprland \
  hyprland-contrib hyprland-qt-support \
  hyprsysteminfo hyprtoolkit gpu-screen-recorder nwg-look matugen \
  sddm \
  grim slurp tesseract tesseract-langpack-eng zbar \
  switcheroo-control \
  brightnessctl ddcutil power-profiles-daemon \
  playerctl alsa-utils pavucontrol \
  gstreamer1-plugins-base gstreamer1-plugins-good \
  gstreamer1-plugins-bad-free gstreamer1-plugins-ugly-free gstreamer1-plugin-libav \
  x264 x265 \
  qt5ct qt6ct qt6-qtwayland papirus-icon-theme \
  exfatprogs ntfs-3g btrfs-progs cifs-utils dosfstools \
  jetbrains-mono-fonts google-noto-color-emoji-fonts adobe-source-code-pro-fonts \
  dbus-tools logrotate gnome-keyring NetworkManager-openvpn \
  NetworkManager-adsl NetworkManager-bluetooth NetworkManager-ppp NetworkManager-wwan \
  zsh \
  ${RAKUOS_RELEASE_PKG} rakuos-software-gtk rakuos-welcome-gtk \
  systemd-oomd-defaults xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs-gtk

## Remove fedora wallpapers
rm -r /usr/share/backgrounds/fedora-workstation/

## Remove fish shell and wofi (not needed with Noctalia)
dnf5 remove -y fish wofi || true

## Unlock keyring on login
sed -i -E 's/^-([a-z]+[[:space:]]+.*pam_gnome_keyring\.so)/\1/' /etc/pam.d/sddm

## Enable Services
systemctl enable sddm
systemctl enable bluetooth
systemctl enable switcheroo-control
systemctl enable tuned
