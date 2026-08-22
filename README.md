# RakuOS Hyprland

Custom RakuOS atomic image: pure Hyprland + NVIDIA, built on `rakuos-base-v3:staging`.

## Features

- Hyprland compositor (Wayland)
- NVIDIA drivers (DKMS, hybrid GPU)
- SDDM display manager
- Rolling release via GitHub Actions (auto-build every Friday)

## Installation

```bash
# First time (switch from official RakuOS)
sudo bootc switch ghcr.io/tofan79/rakuos-hyprland:latest

# After that, updates are automatic
sudo rakuos update
```

## Gaming Setup

After first boot, install gaming packages manually:

```bash
rum install -y \
  gamemode mangohud \
  steam steam-devices gamescope heroic-games-launcher \
  wine winetricks protontricks vulkan-tools goverlay
```

### Packages included:
- **gamemode** - Performance optimizer for games
- **mangohud** - FPS/hardware monitoring overlay
- **steam** - Steam client
- **steam-devices** - Controller support
- **gamescope** - Micro-compositor for games
- **heroic-games-launcher** - Epic/GOG/Amazon launcher
- **wine** - Windows compatibility layer
- **winetricks** - Wine helper scripts
- **protontricks** - Proton/Steam Play helper
- **vulkan-tools** - Vulkan utilities (vkcube, etc)
- **goverlay** - GUI for MangoHud configuration

### Gaming Environment Variables (add to Hyprland config)

```lua
env = [
  LIBVA_DRIVER_NAME,radeonsi
  __GLX_VENDOR_LIBRARY_NAME,nvidia
  GBM_BACKEND,nvidia-drm
  NVD_BACKEND,direct
  MOZ_ENABLE_WAYLAND,1
  QT_QPA_PLATFORM,wayland
  QT_QPA_PLATFORMTHEME,qt6ct
  XDG_SESSION_TYPE,wayland
  XDG_CURRENT_DESKTOP,Hyprland
  GDK_BACKEND,wayland,x11
  QT_WAYLAND_DISABLE_WINDOWDECORATION,1
  _JAVA_AWT_WM_NONREPARENTING,1
  WLR_NO_HARDWARE_CURSORS,1
  WLR_RENDERER vulkan
  SDL_VIDEODRIVER,wayland
  CLUTTER_BACKEND,wayland
  ELECTRON_OZONE_PLATFORM_HINT,auto
```

## Pre-installed Packages

### Core Hyprland
- hyprland, cliphist, xdg-desktop-portal-hyprland
- hyprland-contrib, hyprland-qt-support, hyprsysteminfo, hyprtoolkit
- gpu-screen-recorder, nwg-look, matugen

### Display Manager
- sddm, sddm-kcm

### Screenshot & OCR
- grim, slurp, tesseract, tesseract-langpack-eng, zbar

### Dev Tools
- @development-tools, cmake, meson, ninja-build

### System Tools
- fd-find, tree, bc, lsof, hwinfo, smartmontools, wget2

### Hardware & Power
- switcheroo-control, brightnessctl, ddcutil, power-profiles-daemon

### Network
- NetworkManager-openvpn, NetworkManager-adsl, NetworkManager-bluetooth, NetworkManager-ppp, NetworkManager-wwan

### System
- dbus-tools, logrotate, gnome-keyring, systemd-oomd-defaults
- xdg-desktop-portal, xdg-desktop-portal-gtk, xdg-user-dirs-gtk

### Media
- playerctl, alsa-utils, pavucontrol
- gstreamer1-plugins-base/good/bad-free/ugly-free/libav
- x264, x265

### Theming
- qt5ct, qt6ct, qt6-qtwayland, papirus-icon-theme

### Filesystem
- exfatprogs, ntfs-3g, btrfs-progs, cifs-utils, dosfstools

### Fonts
- jetbrains-mono-fonts, google-noto-color-emoji-fonts, adobe-source-code-pro-fonts

### Terminal
- zsh (uwsm-terminal bawaan base)

### RakuOS
- rakuos-release, rakuos-software-gtk, rakuos-welcome-gtk

## Development

Build locally with Podman:

```bash
podman build \
  --build-arg RAKUOS_STAGING=1 \
  -f Containerfile.nvidia \
  -t rakuos-hyprland:latest \
  .
```

## License

See [LICENSE](LICENSE) for details.
