# rakuos-hyprland

RakuOS Atomic image with pure Hyprland — built on top of `rakuos-base-v3-nvidia`.

## What is Rolling Release?

Rolling release means the system is **always up to date** — no waiting for major version upgrades. Every time you update, you get the latest packages, kernel, and security patches.

```
RakuOS staging (upstream updates)
    ↓
rakuos-base → monitor staging → check if safe?
rakuos-niri → monitor upstream niri → check changes → sync custom
    ↓
rakuos-hyprland (main) → build → GHCR → bootc switch
```

## Why Hyprland?

Hyprland is a dynamic tiling Wayland compositor that's fast, customizable, and modern. This image ships with a **minimal Hyprland setup** — just the core compositor, display manager, and essential tools.

**You choose your shell.** After installation, customize your desktop with:

- **Noctalia** — All-in-one bar, launcher, notifications, wallpaper
- **DankLinux** / **Celestia Shell** — Alternative shell experiences
- **Waybar** + **Wofi** + **Mako** — Classic Hyprland stack
- **AGS** — Custom widget system

The base image is clean — install what you need, skip what you don't.

## What's Inside

| Category | Packages |
|---|---|
| **Hyprland Core** | hyprland, cliphist, xdg-desktop-portal-hyprland, xwayland-satellite |
| **Display Manager** | sddm, sddm-kcm |
| **Screenshot & OCR** | grim, slurp, satty, tesseract, tesseract-data-eng, zbar |
| **Gaming** | switcherooctl, switcheroo-control, gamemode, mangohud |
| **Dev Tools** | @development-tools, cmake, meson, ninja-build |
| **CLI Essentials** | fd-find, tree, bc, lsof, hwinfo, smartmontools, wget2, eza, dua-cli |
| **Hardware & Power** | brightnessctl, ddcutil, power-profiles-daemon |
| **Media** | playerctl, pamixer, alsa-utils, gstreamer1-plugins-*, x264, x265 |
| **Display & Theming** | wlsunset, qt5ct, qt6ct, qt6-wayland, papirus-icon-theme, tela-icon-theme |
| **File System** | exfatprogs, ntfs-3g, btrfs-progs, cifs-utils, dosfstools |
| **Fonts** | jetbrains-mono-fonts, google-noto-color-emoji-fonts, adobe-source-code-pro-fonts |
| **System** | dbus-tools, logrotate, gnome-keyring, networkmanager-openvpn, zram-generator-defaults |
| **Network** | NetworkManager-adsl, NetworkManager-bluetooth, NetworkManager-ppp, NetworkManager-wwan |
| **Terminal & Apps** | ghostty, ghostty-nautilus, nautilus |

## Installation

### Prerequisites

- Laptop with UEFI firmware
- Internet connection
- At least 20GB free space

### Step 1: Install RakuOS

Download and install [RakuOS](https://rakuos.org/download) from the official installer. Choose any desktop edition (GNOME, KDE, or Niri) — it doesn't matter, because we'll switch to Hyprland later.

### Step 2: Switch to RakuOS Hyprland

```bash
sudo bootc switch ghcr.io/tofan79/rakuos-hyprland:latest
```

### Step 3: Reboot

```bash
sudo reboot
```

### Step 4: Login

1. SDDM login screen appears
2. Login with your credentials
3. Hyprland starts automatically

## Customization

### Install your shell

```bash
# Noctalia (all-in-one bar, launcher, notifications)
sudo rum install noctalia

# Hyprland extras
sudo rum install hyprlock hypridle hyprpaper

# Waybar stack
sudo rum install waybar wofi mako
```

### Install flatpak apps

```bash
flatpak install flathub com.spotify.Client
flatpak install flathub org.mozilla.firefox
flatpak install flathub io.github.nickvision.money
```

## Building from Source

### Prerequisites

- Podman or Docker
- Git

### Build

```bash
git clone https://github.com/tofan79/rakuos-hyprland.git
cd rakuos-hyprland

# Build NVIDIA image
podman build -f Containerfile.nvidia -t rakuos-hyprland .
```

### Push to registry

```bash
podman push ghcr.io/tofan79/rakuos-hyprland:latest
```

## Image Tags

| Tag | Description |
|---|---|
| `latest` | Always latest build |
| `<commit-sha>` | Specific version |

## Commands

| Task | Command |
|---|---|
| Trigger build | `git push origin main` |
| Manual build | GitHub Actions → Run workflow |
| Install | `sudo bootc switch ghcr.io/tofan79/rakuos-hyprland:latest` |
| Update | Pull from upstream → build → bootc switch |

## Services Enabled

| Service | Description |
|---|---|
| `sddm` | Display manager |
| `bluetooth` | Bluetooth support |
| `switcheroo-control` | GPU switching (hybrid NVIDIA) |
| `tuned` | Power management |

## Credits

Based on [RakuOS](https://rakuos.org) base images. Licensed under [Apache License 2.0](LICENSE).
