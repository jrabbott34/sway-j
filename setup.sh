#!/usr/bin/env bash
# Deploys all configs from this repo into ~/.config
# Run after install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$REPO_DIR/.config"
CONFIG_DST="$HOME/.config"

deploy() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        echo "  backing up $dst -> $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sf "$src" "$dst"
    echo "  linked $dst"
}

echo "==> Deploying configs..."

for dir in sway waybar swaylock wofi wlogout swaync gtk-3.0 gtk-4.0 foot alacritty fish starship kanshi yazi; do
    src="$CONFIG_SRC/$dir"
    dst="$CONFIG_DST/$dir"
    [[ -d "$src" ]] && deploy "$src" "$dst"
done

# ── libinput-gestures (flat file, not a dir) ──────────────────────────────────
deploy "$CONFIG_SRC/libinput-gestures.conf" "$CONFIG_DST/libinput-gestures.conf"

# ── wallpaper placeholder ─────────────────────────────────────────────────────
WALLPAPER_DST="$HOME/.config/sway/wallpaper.jpg"
if [[ ! -f "$WALLPAPER_DST" ]]; then
    echo ""
    echo "  NOTE: No wallpaper found at $WALLPAPER_DST"
    echo "        Drop any JPEG there, or update the 'set \$wallpaper' line in"
    echo "        ~/.config/sway/config to point at your wallpaper."
fi

# ── screenshots dir ───────────────────────────────────────────────────────────
mkdir -p "$HOME/Pictures"

# ── libinput-gestures systemd user service ────────────────────────────────────
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_USER_DIR"
deploy "$CONFIG_SRC/systemd/user/libinput-gestures.service" \
       "$SYSTEMD_USER_DIR/libinput-gestures.service"
systemctl --user enable --now libinput-gestures.service 2>/dev/null || true

# ── gnome-keyring PAM integration (auto-unlock on GDM login) ─────────────────
PAM_GDM="/etc/pam.d/gdm-password"
if [[ -f "$PAM_GDM" ]] && ! grep -q "pam_gnome_keyring" "$PAM_GDM"; then
    echo "==> Configuring gnome-keyring PAM integration..."
    printf '\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start\n' \
        | sudo tee -a "$PAM_GDM" > /dev/null
    echo "  Done — keyring will auto-unlock on next GDM login."
fi

# ── default shell — optional ──────────────────────────────────────────────────
if command -v fish &>/dev/null; then
    echo ""
    read -rp "==> Set fish as default shell? [y/N] " ans
    if [[ "${ans,,}" == "y" ]]; then
        chsh -s "$(command -v fish)"
        echo "  fish set as default shell (takes effect on next login)"
    fi
fi

# ── grub tokyo night theme ───────────────────────────────────────────────────
GRUB_THEME_SRC="$REPO_DIR/grub/tokyo-night"
GRUB_THEME_DST="/boot/grub/themes/tokyo-night"
if [[ -d "$GRUB_THEME_SRC" ]]; then
    echo ""
    read -rp "==> Deploy GRUB Tokyo Night theme? (requires sudo) [y/N] " ans
    if [[ "${ans,,}" == "y" ]]; then
        sudo mkdir -p "$GRUB_THEME_DST"
        sudo cp "$GRUB_THEME_SRC/theme.txt" "$GRUB_THEME_DST/theme.txt"
        sudo sed -i "s|^#\?GRUB_THEME=.*|GRUB_THEME=\"$GRUB_THEME_DST/theme.txt\"|" /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo "  GRUB theme deployed."
    fi
fi

echo ""
echo "==> Done. Log out and select Sway from your display manager, or run:"
echo "    dbus-run-session sway"
