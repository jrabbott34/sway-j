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
    swayfx
    swaylock-effects
    swayidle
    awww
    waybar
    wofi
    swaync
    wl-clipboard
    wlr-randr
    xdg-desktop-portal-wlr
    wlogout
    kanshi
    wob
)

# ─── system / shell ───────────────────────────────────────────────────────────
SYSTEM_PKGS=(
    curl git wget
    htop btop bat
    eza yazi
    fish
    starship
    cliphist
    jq
    cava
    fastfetch
    cmatrix
    acpi sysstat
    brightnessctl
    power-profiles-daemon
    polkit-gnome
    gnome-keyring seahorse
    timeshift
    yad
    wlsunset
    udiskie
    libinput-gestures
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
    pipewire
    pipewire-alsa
    pipewire-pulse
    wireplumber
    pavucontrol
    playerctl
    mpv
    yt-dlp
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
    thunar-archive-plugin
    gvfs
    gvfs-afc
    gvfs-smb
    samba
    xfce4-settings
    tumbler
    file-roller
    gnome-disk-utility
    dosfstools
)

# ─── screenshot / color ───────────────────────────────────────────────────────
SCREEN_PKGS=(
    grim
    slurp
    hyprpicker
    swappy
)

# ─── appearance ───────────────────────────────────────────────────────────────
APPEARANCE_PKGS=(
    lxappearance-gtk3
    nwg-look
    waypaper
    qt5-wayland
    qt6ct
    papirus-icon-theme
    bibata-cursor-theme
    catppuccin-gtk-theme-mocha
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
    swayimg
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
    blueman
)

# ─── printing ─────────────────────────────────────────────────────────────────
PRINT_PKGS=(
    cups
    cups-pdf
    system-config-printer
    ghostscript
    gsfonts
    gutenprint
    foomatic-db-engine
    foomatic-db
    avahi
    nss-mdns
)

# ─── scanning ─────────────────────────────────────────────────────────────────
SCAN_PKGS=(
    sane
    sane-airscan
    ipp-usb
    simple-scan
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
    gdm-settings
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
    "${PRINT_PKGS[@]}"
    "${SCAN_PKGS[@]}"
    "${KERNEL_PKGS[@]}"
    "${DM_PKGS[@]}"
    "${MISC_PKGS[@]}"
)

echo "==> Installing all packages..."
yay -S --noconfirm --needed "${ALL_PKGS[@]}"

# ─── pacman tweaks ────────────────────────────────────────────────────────────
echo "==> Configuring pacman..."
sudo sed -i 's/^#Color$/Color/'                            /etc/pacman.conf
sudo sed -i 's/^ParallelDownloads = .*/ParallelDownloads = 8/' /etc/pacman.conf
grep -q "^ILoveCandy" /etc/pacman.conf || \
    sudo sed -i '/^ParallelDownloads/a ILoveCandy'         /etc/pacman.conf

# ─── enable services ─────────────────────────────────────────────────────────
echo "==> Enabling services..."
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now avahi-daemon.service
sudo systemctl enable --now cups.socket
sudo systemctl enable --now ipp-usb.service
sudo systemctl enable gdm.service

# ─── input group for libinput-gestures ───────────────────────────────────────
echo "==> Adding $USER to input group (required for gestures)..."
sudo usermod -aG input "$USER"

echo "==> Done. Run ./setup.sh to deploy configs."
