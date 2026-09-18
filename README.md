# DankMaterialShell Pixel Art Theme

A comprehensive retro Pixel Art theme and environment setup for [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), [Helium Browser](https://github.com/imputnet/helium-linux), and [Neovim](https://neovim.io) on Linux (Wayland / Niri / Hyprland).

Features sharp edges, custom pixel typography, pixel-perfect UI icons, 4 color palettes, matching terminal typography, seamless bar docking, browser themes, an animated synthwave pixel art startpage, and a native Neovim colorscheme plugin.

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
- **Helium Browser Integration**:
  - **4 Matching Browser Themes**: Native Chromium/Helium theme manifests for Arcade Neon, PICO-8, Game Boy, and 16-Bit RPG.
  - **Animated Pixel Art Startpage (New Tab)**:
    - Real-time 60fps canvas engine with moving perspective grid, sliced retro glowing sun, jagged mountains, and starfield.
    - Pixel clock with seconds and date.
    - Multi-engine search bar (Google, DuckDuckGo, GitHub, YouTube, Reddit, ArchWiki) with bang shortcuts.
    - Customizable pixel bookmarks grid with modal editor.
    - Config modal: change color themes, adjust grid speed, toggle CRT scanlines, and customize time format.
- **Neovim Colorscheme Plugin (`pixel-art.nvim`)**:
  - Native Lua colorscheme supporting all 4 palettes.
  - Full highlight coverage for Treesitter, LSP diagnostics, NvimTree, CMP, Alpha dashboard, Telescope, Which-Key, and ToggleTerm.
  - Transparent background support out of the box.
  - Included Lualine statusline theme.
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
├── helium/
│   ├── themes/                 # Helium / Chromium browser themes
│   │   ├── arcade-neon/        # Arcade Neon theme manifest
│   │   ├── pico-8/             # PICO-8 theme manifest
│   │   ├── game-boy/           # Game Boy DMG theme manifest
│   │   └── 16bit-rpg/          # 16-Bit RPG theme manifest
│   └── startpage/              # Animated pixel art new tab extension
│       ├── manifest.json       # Extension manifest V3
│       ├── newtab.html         # Startpage layout
│       ├── css/                # Pixel stylesheets and scanlines
│       ├── js/                 # Canvas engine, clock, search, bookmarks
│       └── fonts/              # Embedded pixel typography
├── neovim/                     # Neovim colorscheme plugin
│   ├── colors/                 # Color entry points
│   │   ├── pixel-art.lua
│   │   ├── pixel-art-neon.lua
│   │   ├── pixel-art-pico8.lua
│   │   ├── pixel-art-gameboy.lua
│   │   └── pixel-art-snes.lua
│   └── lua/pixel-art/          # Core plugin modules
│       ├── init.lua
│       ├── palette.lua
│       ├── highlights.lua
│       └── lualine.lua
└── configs/
    ├── dms-settings.json       # Reference DMS configuration
    ├── kitty.conf              # Reference Kitty terminal config
    ├── niri-corner-radius.kdl  # Niri window manager config snippet
    └── nvim-pixel-art.lua      # Neovim Lazy.nvim snippet
```

---

## Prerequisites

- **DankMaterialShell** installed on your system.
- **Dependencies**: `git`, `python3`, `fontconfig` (`fc-cache`).
- **Optional**: [Helium Browser](https://github.com/imputnet/helium-linux), [Neovim](https://neovim.io), [Kitty](https://sw.kovidgoyal.net/kitty/) terminal, [Niri](https://github.com/YaLTeR/niri) window manager.

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
9. Installs Helium Browser themes and animated startpage into `~/.config/net.imput.helium/` and enables them via `~/.config/helium-browser-flags.conf`.
10. Installs the Neovim colorscheme plugin to `~/.local/share/nvim/site/pack/pixel-art/start/pixel-art.nvim`.
11. Restarts DankMaterialShell to apply changes.

---

## Neovim Setup

### Using Lazy.nvim

Add the following spec to your Neovim plugin list (`init.lua` or `lua/plugins/theme.lua`):

```lua
{
  "BJT1698/dms-pixel-art-theme",
  name = "pixel-art.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "arcade-neon", -- "arcade-neon" | "pico-8" | "game-boy" | "16bit-rpg"
    transparent = true,
    styles = {
      comments = { italic = false },
      keywords = { bold = true },
      functions = { bold = true },
      sidebars = "transparent",
      floats = "transparent",
    },
  },
  config = function(_, opts)
    require("pixel-art").setup(opts)
    vim.cmd([[colorscheme pixel-art]])
  end,
}
```

### Animated Pixel Art Welcome Page (Alpha-nvim)

`pixel-art.nvim` includes an animated retro synthwave pixel art header for `alpha-nvim` with smooth frame cycles, sun scanlines, starfield twinkle, and rolling perspective grid lines.

To enable the animated dashboard in your `alpha-nvim` configuration:

```lua
{
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Enable Animated Pixel Art Header
    local ok, pixel_dash = pcall(require, "pixel-art.dashboard")
    if ok and pixel_dash then
      pixel_dash.setup_alpha(dashboard, alpha)
    end

    alpha.setup(dashboard.opts)
  end,
}
```

The animation automatically pauses and consumes zero CPU whenever you navigate away from the dashboard buffer into normal editor buffers.

### Direct Colorscheme Commands

You can load specific variants directly via Vim commands:

```vim
:colorscheme pixel-art         " Loads configured default (Arcade Neon)
:colorscheme pixel-art-neon    " Loads Arcade Neon
:colorscheme pixel-art-pico8   " Loads PICO-8
:colorscheme pixel-art-gameboy " Loads Game Boy DMG
:colorscheme pixel-art-snes    " Loads 16-Bit RPG
```

---

## Helium Browser Setup

### Loading via Extensions Page (Developer Mode)

1. Open Helium and navigate to `helium://extensions` (or `chrome://extensions`).
2. Toggle **Developer mode** in the top-right corner.
3. Click **Load unpacked** and select the directory:
   - For the startpage: `helium/startpage/`
   - For the theme: `helium/themes/arcade-neon/` (or any preferred variant)
4. Open a new tab to see the animated synthwave pixel art startpage.

### Automated Loading via Flags

To load the extension automatically on browser launch, add the following line to `~/.config/helium-browser-flags.conf`:

```conf
--load-extension=/path/to/dms-pixel-art-theme/helium/startpage,/path/to/dms-pixel-art-theme/helium/themes/arcade-neon
```

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

### In DankMaterialShell:
Open DankMaterialShell Settings -> Custom Theme, or edit `theme.json` to swap palettes:
1. **Arcade Neon**
2. **PICO-8**
3. **Game Boy**
4. **16-Bit RPG**

### In Startpage:
Click the **THEME** button in the bottom-right corner or press **T** on the keyboard to cycle through themes in real time.

### In Neovim:
Execute `:colorscheme pixel-art-neon`, `:colorscheme pixel-art-pico8`, `:colorscheme pixel-art-gameboy`, or `:colorscheme pixel-art-snes`.

---

## Uninstallation

To restore previous settings, fonts, and configurations:

```bash
./uninstall.sh
```

---

## License

MIT License. See LICENSE file for details.
