#!/usr/bin/env bash
# ==============================================================================
# DankMaterialShell Pixel Art Theme - Installation Script
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

# Text formatting
CLR_RESET="\033[0m"
CLR_BOLD="\033[1m"
CLR_GREEN="\033[32m"
CLR_BLUE="\033[34m"
CLR_YELLOW="\033[33m"
CLR_RED="\033[31m"

log_info()  { echo -e "${CLR_BLUE}[INFO]${CLR_RESET} $*"; }
log_ok()    { echo -e "${CLR_GREEN}[OK]${CLR_RESET} $*"; }
log_warn()  { echo -e "${CLR_YELLOW}[WARN]${CLR_RESET} $*"; }
log_error() { echo -e "${CLR_RED}[ERROR]${CLR_RESET} $*"; }

echo -e "${CLR_BOLD}=====================================================${CLR_RESET}"
echo -e "${CLR_BOLD}  DankMaterialShell Pixel Art Theme Installer        ${CLR_RESET}"
echo -e "${CLR_BOLD}=====================================================${CLR_RESET}"
echo ""

# 1. Check prerequisites
log_info "Checking prerequisites..."
for cmd in git python3 fc-cache; do
    if ! command -v "$cmd" &>/dev/null; then
        log_error "Required command not found: $cmd. Please install it first."
        exit 1
    fi
done
log_ok "Prerequisites satisfied."

# 2. Install Pixel Fonts
log_info "Installing pixel fonts..."
FONT_DIR="$HOME/.local/share/fonts/pixel-art"
mkdir -p "$FONT_DIR"
cp -r "$SCRIPT_DIR/fonts/"* "$FONT_DIR/"
fc-cache -fv "$FONT_DIR" >/dev/null 2>&1 || fc-cache -f "$FONT_DIR"
log_ok "Fonts installed to $FONT_DIR."

# 3. Install Theme Definition
log_info "Installing theme configuration..."
THEME_DIR="$HOME/.config/DankMaterialShell/themes/pixel-art"
mkdir -p "$THEME_DIR"
cp "$SCRIPT_DIR/theme/theme.json" "$THEME_DIR/theme.json"
log_ok "Theme copied to $THEME_DIR/theme.json."

# 4. Install Wallpapers
log_info "Installing wallpaper..."
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"
cp "$SCRIPT_DIR/wallpapers/"* "$WALLPAPER_DIR/"
log_ok "Wallpaper installed to $WALLPAPER_DIR."

# 5. Setup DMS UI Directory and Pixel Icons
log_info "Setting up DMS UI components and pixel icons..."
DMS_UI_DIR="$HOME/.config/DankMaterialShell/ui"

if [ ! -d "$DMS_UI_DIR" ]; then
    log_info "Downloading DankMaterialShell UI source..."
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/AvengeMedia/DankMaterialShell.git "$TEMP_DIR/dms"
    mkdir -p "$DMS_UI_DIR"
    cp -r "$TEMP_DIR/dms/ui/"* "$DMS_UI_DIR/"
    rm -rf "$TEMP_DIR"
fi

# Copy pixel SVG icons
mkdir -p "$DMS_UI_DIR/DankCommon/assets/pixel-icons"
mkdir -p "$DMS_UI_DIR/assets/pixel-icons"
cp -r "$SCRIPT_DIR/icons/"* "$DMS_UI_DIR/DankCommon/assets/pixel-icons/"
cp -r "$SCRIPT_DIR/icons/"* "$DMS_UI_DIR/assets/pixel-icons/"

# Copy custom DankIcon.qml
mkdir -p "$DMS_UI_DIR/DankCommon/Widgets"
cp "$SCRIPT_DIR/dms-components/DankIcon.qml" "$DMS_UI_DIR/DankCommon/Widgets/DankIcon.qml"
if [ -d "$DMS_UI_DIR/Widgets" ]; then
    cp "$SCRIPT_DIR/dms-components/DankIcon.qml" "$DMS_UI_DIR/Widgets/DankIcon.qml"
fi

# Configure environment variable for DMS UI
ENV_DIR="$HOME/.config/environment.d"
mkdir -p "$ENV_DIR"
ENV_FILE="$ENV_DIR/dms.conf"
if [ -f "$ENV_FILE" ]; then
    if ! grep -q "DMS_SHELL_DIR" "$ENV_FILE"; then
        echo "DMS_SHELL_DIR=$DMS_UI_DIR" >> "$ENV_FILE"
    fi
else
    echo "DMS_SHELL_DIR=$DMS_UI_DIR" > "$ENV_FILE"
fi
log_ok "DMS UI and pixel icons configured."

# 6. Install Pixora Icon Theme (for App Icons)
log_info "Setting up Pixora pixel art app icons..."
ICONS_DIR="$HOME/.local/share/icons"
mkdir -p "$ICONS_DIR"
if [ ! -d "$ICONS_DIR/Pixora" ]; then
    git clone --depth 1 https://github.com/tsora1603/pixora-icons.git "$ICONS_DIR/Pixora"
fi
ln -sfn "$ICONS_DIR/Pixora/pixora" "$ICONS_DIR/pixora"
ln -sfn "$ICONS_DIR/Pixora/pixora-dark" "$ICONS_DIR/pixora-dark"
log_ok "Pixora icon theme linked."

# 7. Update DMS settings.json
log_info "Updating DankMaterialShell settings..."
DMS_CONFIG_DIR="$HOME/.config/DankMaterialShell"
mkdir -p "$DMS_CONFIG_DIR"
SETTINGS_FILE="$DMS_CONFIG_DIR/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.bak.$TIMESTAMP"
    log_info "Existing settings backed up to $SETTINGS_FILE.bak.$TIMESTAMP"
fi

python3 - <<EOF
import json
import os

settings_path = os.path.expanduser("~/.config/DankMaterialShell/settings.json")
theme_path = os.path.expanduser("~/.config/DankMaterialShell/themes/pixel-art/theme.json")

data = {}
if os.path.exists(settings_path):
    try:
        with open(settings_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception:
        data = {}

data["currentThemeName"] = "custom"
data["currentThemeCategory"] = "custom"
data["customThemeFile"] = theme_path
data["cornerRadius"] = 0
data["niriLayoutRadiusOverride"] = 0
data["fontFamily"] = "Silkscreen"
data["monoFontFamily"] = "Silkscreen"
data["iconThemeDark"] = "pixora-dark"
data["iconThemeLight"] = "pixora"
data["enableRippleEffects"] = False
data["m3ElevationEnabled"] = False
data["modalElevationEnabled"] = False
data["popoutElevationEnabled"] = False
data["barElevationEnabled"] = False

if "barConfigs" in data and isinstance(data["barConfigs"], list) and len(data["barConfigs"]) > 0:
    for bar in data["barConfigs"]:
        bar["squareCorners"] = True
        bar["position"] = 1
        bar["attachToScreenEdge"] = True
        bar["spacing"] = 0
        bar["innerPadding"] = 0
        bar["barInsetPadding"] = 0
        bar["barLengthPadding"] = 0
        bar["bottomGap"] = 0
        bar["noBackground"] = True
        bar["widgetTransparency"] = 0
        bar["borderEnabled"] = False
        bar["borderThickness"] = 0
        bar["widgetOutlineEnabled"] = False
        bar["shadowIntensity"] = 0
        bar["shadowOpacity"] = 0

with open(settings_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2)

print("DMS settings successfully updated.")
EOF
log_ok "DankMaterialShell settings updated."

# 8. Configure Kitty Terminal
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
if [ -f "$KITTY_CONF" ]; then
    log_info "Configuring Kitty font..."
    cp "$KITTY_CONF" "$KITTY_CONF.bak.$TIMESTAMP"
    if grep -q "^font_family" "$KITTY_CONF"; then
        sed -i 's/^font_family .*/font_family      Monocraft/' "$KITTY_CONF"
    else
        echo -e "\nfont_family      Monocraft\n" >> "$KITTY_CONF"
    fi
    log_ok "Kitty font set to Monocraft (backup created at $KITTY_CONF.bak.$TIMESTAMP)."
fi

# 9. Configure Helium Browser Theme & Startpage
if command -v helium-browser &>/dev/null || [ -d "$HOME/.config/net.imput.helium" ]; then
    log_info "Configuring Helium Browser theme and animated startpage..."
    HELIUM_DIR="$HOME/.config/net.imput.helium"
    mkdir -p "$HELIUM_DIR/themes"
    mkdir -p "$HELIUM_DIR/startpage"
    cp -r "$SCRIPT_DIR/helium/themes/"* "$HELIUM_DIR/themes/"
    cp -r "$SCRIPT_DIR/helium/startpage/"* "$HELIUM_DIR/startpage/"

    # Setup flags to load extension automatically
    HELIUM_FLAGS="$HOME/.config/helium-browser-flags.conf"
    EXT_PATH="$HELIUM_DIR/startpage"
    THEME_PATH="$HELIUM_DIR/themes/arcade-neon"
    LOAD_EXT_FLAG="--load-extension=$EXT_PATH,$THEME_PATH"

    if [ -f "$HELIUM_FLAGS" ]; then
        if ! grep -q "\-\-load-extension=" "$HELIUM_FLAGS"; then
            echo "$LOAD_EXT_FLAG" >> "$HELIUM_FLAGS"
        fi
    else
        echo "$LOAD_EXT_FLAG" > "$HELIUM_FLAGS"
    fi
    log_ok "Helium Browser theme and animated startpage installed."
fi

# 10. Install Neovim Pixel Art Plugin
log_info "Installing Neovim Pixel Art theme plugin..."
NVIM_PACK_DIR="$HOME/.local/share/nvim/site/pack/pixel-art/start/pixel-art.nvim"
mkdir -p "$NVIM_PACK_DIR"
cp -r "$SCRIPT_DIR/neovim/"* "$NVIM_PACK_DIR/"
log_ok "Neovim plugin installed to $NVIM_PACK_DIR."

# 11. Restart DMS if running
log_info "Applying changes..."
if systemctl --user is-active dms.service &>/dev/null; then
    systemctl --user restart dms.service
    log_ok "DMS systemd service restarted."
elif pgrep -x dms &>/dev/null; then
    pkill -x dms || true
    nohup dms >/dev/null 2>&1 &
    log_ok "DMS process restarted."
fi

echo ""
echo -e "${CLR_BOLD}${CLR_GREEN}Installation complete!${CLR_RESET}"
echo -e "DMS, Kitty, Helium Browser, and Neovim have been configured with the Pixel Art theme."
