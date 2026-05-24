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

for dir in sway waybar swaylock wofi dunst foot alacritty; do
    src="$CONFIG_SRC/$dir"
    dst="$CONFIG_DST/$dir"
    [[ -d "$src" ]] && deploy "$src" "$dst"
done

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

# ── default shell — optional ──────────────────────────────────────────────────
if command -v fish &>/dev/null; then
    echo ""
    read -rp "==> Set fish as default shell? [y/N] " ans
    if [[ "${ans,,}" == "y" ]]; then
        chsh -s "$(command -v fish)"
        echo "  fish set as default shell (takes effect on next login)"
    fi
fi

echo ""
echo "==> Done. Log out and select Sway from your display manager, or run:"
echo "    dbus-run-session sway"
