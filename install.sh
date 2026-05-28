#!/usr/bin/env bash
set -euo pipefail

# ─── install yay if missing ───────────────────────────────────────────────────
if ! command -v yay &>/dev/null; then
    echo "==> Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay-build
    (cd /tmp/yay-build && makepkg -si --noconfirm)
    rm -rf /tmp/yay-build
fi

# ─── core sway stack ──────────────────────────────────────────────────────────
SWAY_PKGS=(
    sway
    swaylock
    swayidle
    awww
    waybar
    wofi
    dunst
    wl-clipboard
    wlr-randr
    xdg-desktop-portal-wlr
    wlogout
)

# ─── system / shell ───────────────────────────────────────────────────────────
SYSTEM_PKGS=(
    curl git wget
    htop btop bat
    eza yazi
    fish zsh
    jq go
    cava
    acpi sysstat
    brightnessctl
    power-profiles-daemon
    polkit-gnome
    gnome-keyring seahorse
    timeshift
    yad
)

# ─── network ─────────────────────────────────────────────────────────────────
NETWORK_PKGS=(
    iw
    network-manager-applet
    networkmanager-openvpn
    openvpn
)

# ─── audio / media ───────────────────────────────────────────────────────────
MEDIA_PKGS=(
    pulseaudio
    pulseaudio-alsa
    pulseaudio-bluetooth
    pavucontrol
    mpv
    yt-dlp
    redshift
)

# ─── terminals ────────────────────────────────────────────────────────────────
TERMINAL_PKGS=(
    alacritty
    foot
)

# ─── file management ──────────────────────────────────────────────────────────
FILE_PKGS=(
    thunar
    thunar-volman
    gvfs
    gvfs-afc
    gvfs-smb
    samba
    xfce4-settings
    tumbler
    gnome-disk-utility
    dosfstools
)

# ─── screenshot / color ───────────────────────────────────────────────────────
SCREEN_PKGS=(
    grim
    slurp
    hyprpicker
)

# ─── appearance ───────────────────────────────────────────────────────────────
APPEARANCE_PKGS=(
    lxappearance-gtk3
    nwg-look
    waypaper
    qt5-wayland
    qt6ct
    ttf-font-awesome
    ttf-firacode-nerd
    ttf-ms-fonts
    powerline-fonts-git
    woff2-font-awesome
)

# ─── browser / office ────────────────────────────────────────────────────────
APP_PKGS=(
    firefox
    gedit
    libreoffice-fresh
)

# ─── virtualization / remote ─────────────────────────────────────────────────
VIRT_PKGS=(
    virt-manager
    qemu
    libvirt
    edk2-ovmf
    dnsmasq
    iptables-nft
    qemu-guest-agent
    spice-vdagent
    virt-viewer
    remmina
    freerdp
)

# ─── bluetooth ────────────────────────────────────────────────────────────────
BT_PKGS=(
    bluez
    bluez-utils
)

# ─── kernel / firmware ────────────────────────────────────────────────────────
KERNEL_PKGS=(
    linux
    linux-firmware
    linux-headers
    intel-ucode
)

# ─── display manager ─────────────────────────────────────────────────────────
DM_PKGS=(
    gdm
)

# ─── misc / aur ───────────────────────────────────────────────────────────────
MISC_PKGS=(
    trezor-suite-bin
)

ALL_PKGS=(
    "${SWAY_PKGS[@]}"
    "${SYSTEM_PKGS[@]}"
    "${NETWORK_PKGS[@]}"
    "${MEDIA_PKGS[@]}"
    "${TERMINAL_PKGS[@]}"
    "${FILE_PKGS[@]}"
    "${SCREEN_PKGS[@]}"
    "${APPEARANCE_PKGS[@]}"
    "${APP_PKGS[@]}"
    "${VIRT_PKGS[@]}"
    "${BT_PKGS[@]}"
    "${KERNEL_PKGS[@]}"
    "${DM_PKGS[@]}"
    "${MISC_PKGS[@]}"
)

echo "==> Installing all packages..."
yay -S --noconfirm --needed "${ALL_PKGS[@]}"

# ─── enable services ─────────────────────────────────────────────────────────
echo "==> Enabling services..."
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable gdm.service

echo "==> Done. Run ./setup.sh to deploy configs."
