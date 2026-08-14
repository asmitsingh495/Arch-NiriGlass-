#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

# Define color codes for console feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths configuration
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# 1. Install 'dialog' first to render the terminal GUI
if ! command -v dialog &>/dev/null || ! pacman -Qi base-devel &>/dev/null; then
    echo -e "${BLUE}Preparing terminal GUI interface and build tools (base-devel)...${NC}"
    sudo pacman -S --needed --noconfirm dialog base-devel git
fi

# 2. GUI Welcome Box
dialog --title "🌌 NiriGlass Installer" --msgbox "\nWelcome to the NiriGlass Automated Customization Script!\n\nThis script will install Niri WM, all required core packages, system fonts, and apply your customized configurations automatically." 12 70

# 3. List of core packages to install (including proper fonts)
PACKAGES=(
    "niri" "Scrollable tiling Wayland compositor" ON
    "waybar" "Highly customizable status bar" ON
    "alacritty" "GPU-accelerated terminal emulator" ON
    "mako" "Lightweight notification daemon" ON
    "fuzzel" "Wayland native application launcher" ON
    "neofetch" "CLI system information tool" ON
    "nwg-look" "GTK3 settings editor for Wayland" ON
    "zsh" "Advanced interactive shell environment" ON
    "swaybg" "Wallpaper utility for Wayland" ON
    "ttf-nerd-fonts-symbols-common" "Symbols Nerd Font for Waybar icons" ON
    "ttf-jetbrains-mono-nerd" "Developer preferred clean font" ON
    "noto-fonts-emoji" "System wide colorful emoji support" ON
)

# 4. GUI Checklist selection
CHOICES=$(dialog --stdout --title "📦 Select Official Packages" \
    --checklist "Press [Spacebar] to select/deselect packages, then press Enter:" 22 75 13 \
    "${PACKAGES[@]}")

# Exit gracefully if user cancels
if [ -z "$CHOICES" ]; then
    clear
    echo -e "${RED}Installation cancelled by user.${NC}"
    exit 1
fi
INST_LIST=$(echo "$CHOICES" | tr -d '"')

# 5. AUR Helper prompt menu
AUR_CHOICE=$(dialog --stdout --title "⚙️ AUR Helper Installation" \
    --menu "Which AUR Helper would you like to install?" 15 60 4 \
    "1" "yay (Written in Go - Most Popular)" \
    "2" "paru (Written in Rust - Extremely Fast)" \
    "3" "Install Both (yay and paru)" \
    "4" "None (Skip AUR helper setup)")

# 6. Install selected official packages
clear
echo -e "${BLUE}Installing selected core packages... This might take a moment.${NC}"
sudo pacman -S --needed --noconfirm $INST_LIST

# 7. Safe non-root AUR installation logic
install_aur_helper() {
    local helper_name=$1
    if ! command -v "$helper_name" &>/dev/null; then
        echo -e "${BLUE}\nCloning and compiling $helper_name from the AUR...${NC}"
        rm -rf "/tmp/$helper_name"
        git clone "https://archlinux.org" "/tmp/$helper_name"
        cd "/tmp/$helper_name"
        # Executing makepkg without sudo as per secure guidelines
        makepkg -si --noconfirm
        cd "$REPO_DIR"
        echo -e "${GREEN}✓ $helper_name installed successfully!${NC}"
    else
        echo -e "${GREEN}✓ $helper_name is already installed.${NC}"
    fi
}

case "$AUR_CHOICE" in
    1) install_aur_helper "yay" ;;
    2) install_aur_helper "paru" ;;
    3) 
        install_aur_helper "yay"
        install_aur_helper "paru"
        ;;
    *) echo -e "${BLUE}AUR Helper setup skipped.${NC}" ;;
esac

# 8. Automated backup routine for safety
echo -e "\n${BLUE}Backing up existing configurations for safety...${NC}"
mkdir -p "$BACKUP_DIR"

backup_configs() {
    if [ -e "$CONFIG_DIR/$1" ]; then
        mv "$CONFIG_DIR/$1" "$BACKUP_DIR/" 2>/dev/null || true
    fi
}

for item in niri waybar alacritty mako fuzzel neofetch nwg-look; do
    backup_configs "$item"
done
if [ -f "$HOME/.zshrc" ]; then cp "$HOME/.zshrc" "$BACKUP_DIR/"; fi

echo -e "${GREEN}Backups saved safely at: $BACKUP_DIR${NC}"

# 9. Deploying Google Drive custom configurations
echo -e "\n${GREEN}Applying your custom configuration profiles...${NC}"
mkdir -p "$CONFIG_DIR"

apply_config() {
    if [ -d "$REPO_DIR/config/$1" ]; then
        cp -r "$REPO_DIR/config/$1" "$CONFIG_DIR/"
        echo "✓ Successfully deployed $1 config"
    else
        echo -e "${RED}⚠ Warning: $1 configuration folder not found in your repository path${NC}"
    fi
}

for item in niri waybar alacritty mako fuzzel neofetch nwg-look; do
    apply_config "$item"
done

# Oh-My-Zsh & interactive environment profile layout setup
if [ -d "$REPO_DIR/config/oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
    cp -r "$REPO_DIR/config/oh-my-zsh" "$HOME/.oh-my-zsh"
fi
if [ -f "$REPO_DIR/config/zsh/.zshrc" ]; then
    cp "$REPO_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
fi

# 10. Success UI Box
dialog --title "🎉 Installation Successful!" --msgbox "\nCongratulations!\n\nAll custom dotfiles, system fonts, themes, and chosen AUR tools have been successfully deployed.\n\nPlease log out and select Niri from your display manager." 13 70

clear
echo -e "${GREEN}===============================================${NC}"
echo -e "${GREEN}  🌌 NiriGlass GUI Installation Complete! 🎉    ${NC}"
echo -e "${GREEN}===============================================${NC}"
