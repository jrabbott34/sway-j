# swayfx build

Arch Linux · Sway (Wayland) dotfiles and installer.
Built as a clean alternative to Hyprland (no `.lua` configs).

## Quick start

```bash
# 1. Install all packages (installs yay if missing)
chmod +x install.sh && ./install.sh

# 2. Deploy configs to ~/.config
chmod +x setup.sh && ./setup.sh

# 3. Drop a wallpaper
cp /path/to/your/wallpaper.jpg ~/.config/sway/wallpaper.jpg

# 4. Start Sway
dbus-run-session sway
```

---

## Waybar modules

| Position | Modules |
|----------|---------|
| Left     | Workspaces 1–5 · Sway mode indicator · Scratchpad count |
| Center   | Clock (hover = calendar tooltip · click = yad calendar popup) |
| Right    | Network · Audio · CPU · RAM · Battery · System tray |

---

## Key bindings

| Binding | Action |
|---------|--------|
| `Super + Return` | Terminal (alacritty) |
| `Super + Space` | App launcher (wofi) |
| `Super + E` | File manager (thunar) |
| `Super + B` | Firefox |
| `Super + L` | Lock screen (swaylock) |
| `Super + Shift + E` | Logout menu (wlogout) |
| `Print` | Full screenshot → ~/Pictures |
| `Super + Print` | Area screenshot → ~/Pictures |
| `Super + Shift + Print` | Area screenshot → clipboard |
| `Super + C` | Color picker (hyprpicker) |
| `Super + 1–5` | Switch workspace |
| `Super + Shift + 1–5` | Move window to workspace |
| `Super + F` | Fullscreen |
| `Super + Shift + Q` | Close window |
| `Super + Shift + R` | Reload Sway config |
| `Super + R` | Resize mode |

---

## Theme

**Tokyo Night** color palette across Sway, Waybar, swaylock, Wofi, Dunst, foot, and Alacritty.
Font: **FiraCode Nerd Font**

---

## Hyprland → Sway replacements

| Hyprland | Sway equivalent |
|----------|----------------|
| `hyprland` | `sway` |
| `hyprpaper` | `swaybg` |
| `hypridle` | `swayidle` |
| `hyprlock` | `swaylock` |
| `xdg-desktop-portal-hyprland` | `xdg-desktop-portal-wlr` |
| `hyprcursor` / `hyprutils` / `hyprwayland-scanner` | removed |

---

## Monitor configuration

Run `swaymsg -t get_outputs` to list output names, then edit `~/.config/sway/config`:

```
output eDP-1 resolution 1920x1080 position 0,0 scale 1
output HDMI-A-1 resolution 2560x1440 position 1920,0 scale 1
```
