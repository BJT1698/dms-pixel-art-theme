# DankMaterialShell Pixel Art Theme

A comprehensive retro Pixel Art theme and environment setup for [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) on Linux (Wayland / Niri / Hyprland).

Features sharp edges, custom pixel typography, pixel-perfect UI icons, 4 color palettes, matching terminal typography, and seamless bar docking.

---

## Features

- **4 Custom Color Schemes**:
  - **Arcade Neon** (Default): High-contrast synthwave neon on deep violet.
  - **PICO-8**: Authentic fantasy console 16-color palette.
  - **Game Boy**: Classic 4-shade greenish phosphor retro handheld aesthetic.
  - **16-Bit RPG**: Warm nostalgic palette inspired by classic SNES RPGs.
- **Pixel Typography**:
  - **Silkscreen**: Crisp, legible pixel font for shell widgets, menus, and notifications.
  - **Monocraft**: True monospaced pixel font for Kitty terminal.
  - **Press Start 2P, Tiny5, VT323, PixeloidMono**: Included in the font pack.
- **Pixel UI Icons**:
  - Over 70 handcrafted white 16x16 SVG pixel icons for status bar controls (WiFi, Bluetooth, Battery, Volume, Notifications, Settings, Power, etc.).
  - Custom `DankIcon` QML component with 1:1 aspect-ratio preservation and dynamic theme colorization.
- **Sharp Geometry**:
  - Complete removal of border radius across the bar, popups, and widgets (`cornerRadius: 0`).
  - Bar configured as a docked edge strip with no padding or backgrounds.
- **System App Icons**:
  - Pixora pixel art application icon theme integration.
- **Wallpaper**:
  - Generated pixel art synthwave sunset wallpaper.

---

## Repository Structure

```
.
├── install.sh                  # Automated installer script
├── uninstall.sh                # Automated uninstaller script
├── README.md                   # Documentation
├── theme/
│   └── theme.json              # DMS theme file with all 4 variants
├── fonts/                      # Pixel fonts (Silkscreen, Monocraft, etc.)
├── icons/                      # 16x16 SVG pixel art UI icons
├── dms-components/
│   └── DankIcon.qml            # Custom QML component for pixel icon rendering
├── wallpapers/
│   └── pixel_art_neon_horizon.jpg
└── configs/
    ├── dms-settings.json       # Reference DMS configuration
    ├── kitty.conf              # Reference Kitty terminal config
    └── niri-corner-radius.kdl  # Niri window manager config snippet
```

---

## Prerequisites

- **DankMaterialShell** installed on your system.
- **Dependencies**: `git`, `python3`, `fontconfig` (`fc-cache`).
- **Optional**: [Kitty](https://sw.kovidgoyal.net/kitty/) terminal, [Niri](https://github.com/YaLTeR/niri) window manager.

---

## Automated Installation

Run the installation script:

```bash
./install.sh
```

### What the installer does:

1. Installs pixel fonts to `~/.local/share/fonts/pixel-art` and updates the font cache.
2. Installs `theme.json` to `~/.config/DankMaterialShell/themes/pixel-art/theme.json`.
3. Installs the wallpaper to `~/Pictures/Wallpapers/`.
4. Clones the DMS UI (if not already local) and installs pixel icons and the modified `DankIcon.qml`.
5. Sets `DMS_SHELL_DIR` in `~/.config/environment.d/dms.conf`.
6. Downloads and links the Pixora icon theme for applications.
7. Backs up existing `settings.json` and configures DMS with zero corner radius, pixel fonts, and edge docking.
8. Configures Kitty with `Monocraft` font (with automatic backup).
9. Restarts DankMaterialShell to apply changes.

---

## Manual Installation

### 1. Fonts
Copy all fonts from `fonts/` to your user fonts directory and refresh cache:
```bash
mkdir -p ~/.local/share/fonts/pixel-art
cp fonts/* ~/.local/share/fonts/pixel-art/
fc-cache -fv ~/.local/share/fonts/pixel-art
```

### 2. Theme File
Copy `theme/theme.json`:
```bash
mkdir -p ~/.config/DankMaterialShell/themes/pixel-art
cp theme/theme.json ~/.config/DankMaterialShell/themes/pixel-art/theme.json
```

### 3. DMS UI and Pixel Icons
If using local UI customization, set `DMS_SHELL_DIR`:
```bash
mkdir -p ~/.config/DankMaterialShell/ui/DankCommon/assets/pixel-icons
mkdir -p ~/.config/DankMaterialShell/ui/DankCommon/Widgets
cp icons/* ~/.config/DankMaterialShell/ui/DankCommon/assets/pixel-icons/
cp dms-components/DankIcon.qml ~/.config/DankMaterialShell/ui/DankCommon/Widgets/DankIcon.qml
echo "DMS_SHELL_DIR=$HOME/.config/DankMaterialShell/ui" >> ~/.config/environment.d/dms.conf
```

### 4. Application Icons (Pixora)
```bash
git clone --depth 1 https://github.com/tsora1603/pixora-icons.git ~/.local/share/icons/Pixora
ln -s ~/.local/share/icons/Pixora/pixora ~/.local/share/icons/pixora
ln -s ~/.local/share/icons/Pixora/pixora-dark ~/.local/share/icons/pixora-dark
```

### 5. DankMaterialShell Settings
In DMS Settings (`~/.config/DankMaterialShell/settings.json` or Settings UI):
- **Theme**: Custom -> Select `~/.config/DankMaterialShell/themes/pixel-art/theme.json`
- **Corner Radius**: `0`
- **Font Family**: `Silkscreen`
- **Monospace Font**: `Silkscreen`
- **Icon Theme Dark**: `pixora-dark`
- **Icon Theme Light**: `pixora`
- **DankBar Settings**: Position: Bottom (1), Attach to edge: Yes, Inner Padding: 0, Spacing: 0, No Background: Yes, Widget Transparency: 0.

### 6. Kitty Terminal
In `~/.config/kitty/kitty.conf`:
```conf
font_family      Monocraft
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        12.0
```

### 7. Niri Window Manager (Optional)
In `~/.config/niri/config.kdl`:
```kdl
prefer-no-csd

layout {
    geometry-corner-radius 0
}

window-rule {
    geometry-corner-radius 0
    clip-to-geometry true
}
```

---

## Switching Variants

Open DankMaterialShell Settings -> Custom Theme, or edit `theme.json` to swap palettes:
1. **Arcade Neon**
2. **PICO-8**
3. **Game Boy**
4. **16-Bit RPG**

---

## Uninstallation

To restore previous settings, fonts, and configurations:

```bash
./uninstall.sh
```

---

## License

MIT License. See LICENSE file for details.
