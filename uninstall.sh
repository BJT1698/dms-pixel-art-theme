#!/usr/bin/env bash
# ==============================================================================
# DankMaterialShell Pixel Art Theme - Uninstallation Script
# ==============================================================================
set -euo pipefail

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
echo -e "${CLR_BOLD}  DankMaterialShell Pixel Art Theme Uninstaller      ${CLR_RESET}"
echo -e "${CLR_BOLD}=====================================================${CLR_RESET}"
echo ""

# 1. Remove Pixel Fonts
FONT_DIR="$HOME/.local/share/fonts/pixel-art"
if [ -d "$FONT_DIR" ]; then
    log_info "Removing pixel fonts..."
    rm -rf "$FONT_DIR"
    fc-cache -f >/dev/null 2>&1 || true
    log_ok "Fonts removed."
fi

# 2. Remove Theme
THEME_DIR="$HOME/.config/DankMaterialShell/themes/pixel-art"
if [ -d "$THEME_DIR" ]; then
    log_info "Removing theme directory..."
    rm -rf "$THEME_DIR"
    log_ok "Theme removed."
fi

# 3. Clean up Environment Configuration
ENV_FILE="$HOME/.config/environment.d/dms.conf"
if [ -f "$ENV_FILE" ]; then
    log_info "Cleaning up environment variables..."
    sed -i '/DMS_SHELL_DIR/d' "$ENV_FILE"
    if [ ! -s "$ENV_FILE" ]; then
        rm -f "$ENV_FILE"
    fi
    log_ok "Environment configuration cleaned."
fi

# 4. Clean up Helium Browser configuration
HELIUM_DIR="$HOME/.config/net.imput.helium"
if [ -d "$HELIUM_DIR/themes" ]; then
    rm -rf "$HELIUM_DIR/themes"
fi
if [ -d "$HELIUM_DIR/startpage" ]; then
    rm -rf "$HELIUM_DIR/startpage"
fi
HELIUM_FLAGS="$HOME/.config/helium-browser-flags.conf"
if [ -f "$HELIUM_FLAGS" ]; then
    sed -i '/\-\-load-extension/d' "$HELIUM_FLAGS"
    if [ ! -s "$HELIUM_FLAGS" ]; then
        rm -f "$HELIUM_FLAGS"
    fi
fi
log_ok "Helium Browser theme and startpage removed."

# 5. Remove Neovim Plugin
NVIM_PACK_DIR="$HOME/.local/share/nvim/site/pack/pixel-art"
if [ -d "$NVIM_PACK_DIR" ]; then
    log_info "Removing Neovim plugin..."
    rm -rf "$NVIM_PACK_DIR"
    log_ok "Neovim plugin removed."
fi

# 6. Clean up Greeter UI
GREETER_UI_DIR="$HOME/.config/DankMaterialShell/greeter-ui"
if [ -d "$GREETER_UI_DIR" ]; then
    log_info "Removing Greeter pixel art UI..."
    rm -rf "$GREETER_UI_DIR"
    GREETD_CONF="/etc/greetd/config.toml"
    if [ -w "$GREETD_CONF" ]; then
        sed -i "s| -c $GREETER_UI_DIR||g" "$GREETD_CONF"
    fi
    log_ok "Greeter UI removed and greetd configuration restored."
fi

# 7. Restore or Reset DMS Settings
DMS_CONFIG_DIR="$HOME/.config/DankMaterialShell"
SETTINGS_FILE="$DMS_CONFIG_DIR/settings.json"
LATEST_BACKUP=$(ls -t "$DMS_CONFIG_DIR"/settings.json.bak.* 2>/dev/null | head -n 1 || true)

if [ -n "$LATEST_BACKUP" ] && [ -f "$LATEST_BACKUP" ]; then
    log_info "Restoring DMS settings from backup: $LATEST_BACKUP..."
    cp "$LATEST_BACKUP" "$SETTINGS_FILE"
    log_ok "Settings restored from backup."
elif [ -f "$SETTINGS_FILE" ]; then
    log_info "Resetting DMS settings to default values..."
    python3 - <<EOF
import json
import os

settings_path = os.path.expanduser("~/.config/DankMaterialShell/settings.json")
try:
    with open(settings_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    if data.get("currentThemeName") == "custom":
        data["currentThemeName"] = "gruvbox-material-medium"
        data["currentThemeCategory"] = "dark"
    data["cornerRadius"] = 12
    data["fontFamily"] = "Roboto"
    data["monoFontFamily"] = "Roboto Mono"
    with open(settings_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
except Exception as e:
    print(f"Notice: {e}")
EOF
    log_ok "Settings reset."
fi

# 8. Restore Kitty Configuration
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
KITTY_BACKUP=$(ls -t "$HOME/.config/kitty"/kitty.conf.bak.* 2>/dev/null | head -n 1 || true)
if [ -n "$KITTY_BACKUP" ] && [ -f "$KITTY_BACKUP" ]; then
    log_info "Restoring Kitty configuration from backup: $KITTY_BACKUP..."
    cp "$KITTY_BACKUP" "$KITTY_CONF"
    log_ok "Kitty configuration restored."
fi

# 9. Restart DMS
log_info "Restarting DankMaterialShell..."
if systemctl --user is-active dms.service &>/dev/null; then
    systemctl --user restart dms.service
    log_ok "DMS service restarted."
elif pgrep -x dms &>/dev/null; then
    pkill -x dms || true
    nohup dms >/dev/null 2>&1 &
    log_ok "DMS process restarted."
fi

echo ""
echo -e "${CLR_BOLD}${CLR_GREEN}Uninstallation complete!${CLR_RESET}"
