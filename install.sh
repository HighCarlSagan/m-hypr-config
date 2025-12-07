#!/bin/bash

echo "=========================================="
echo "  M-Hypr-Config Installation Script"
echo "=========================================="
echo ""

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo "❌ This script is designed for Arch Linux only!"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}⚠️  This will install packages and overwrite existing configs!${NC}"
read -p "Continue? (y/n): " choice
if [ "$choice" != "y" ]; then
    echo "Installation cancelled."
    exit 0
fi

# Backup existing configs
echo ""
echo -e "${YELLOW}📦 Backing up existing configs...${NC}"
BACKUP_DIR=~/.config-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"
cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/rofi "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/kitty "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/cava "$BACKUP_DIR/" 2>/dev/null
echo -e "${GREEN}✅ Backup saved to: $BACKUP_DIR${NC}"

# Install yay if not present
echo ""
echo -e "${YELLOW}📦 Checking for yay (AUR helper)...${NC}"
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"
    echo -e "${GREEN}✅ yay installed${NC}"
else
    echo -e "${GREEN}✅ yay already installed${NC}"
fi

# Install essential packages
echo ""
echo -e "${YELLOW}📦 Installing essential packages...${NC}"
sudo pacman -S --needed --noconfirm \
    hyprland \
    waybar \
    rofi \
    kitty \
    firefox \
    dolphin \
    polkit-gnome \
    swww \
    hyprlock \
    hyprshot \
    playerctl \
    pavucontrol \
    blueman \
    brightnessctl \
    networkmanager \
    git \
    curl \
    wget \
    openssh \
    yad \
    imagemagick \
    cava \
    openrgb \
    base-devel

echo -e "${GREEN}✅ Essential packages installed${NC}"

# Install AUR packages
echo ""
echo -e "${YELLOW}📦 Installing AUR packages...${NC}"
yay -S --needed --noconfirm \
    brave-bin \
    spotify \
    whatsapp-for-linux-git \
    hypr-dots \
    tailscale

echo -e "${GREEN}✅ AUR packages installed${NC}"

# Copy configs
echo ""
echo -e "${YELLOW}📋 Installing configurations...${NC}"

mkdir -p ~/.config/{hypr,waybar,rofi,kitty,cava,OpenRGB}
mkdir -p ~/.local/bin
mkdir -p ~/Pictures/Wallpapers

cp -r configs/hypr/* ~/.config/hypr/
cp -r configs/waybar/* ~/.config/waybar/
cp -r configs/rofi/* ~/.config/rofi/
cp -r configs/kitty/* ~/.config/kitty/
cp -r configs/cava/* ~/.config/cava/
cp -r configs/OpenRGB/* ~/.config/OpenRGB/ 2>/dev/null
cp -r scripts/* ~/.local/bin/
cp -r wallpapers/* ~/Pictures/Wallpapers/

# Make scripts executable
chmod +x ~/.local/bin/*
chmod +x ~/.config/waybar/scripts/*

echo -e "${GREEN}✅ Configurations installed${NC}"

# Set up services
echo ""
echo -e "${YELLOW}⚙️  Configuring services...${NC}"

# SSH
sudo systemctl enable sshd
sudo systemctl start sshd

# Bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Tailscale
sudo systemctl enable tailscaled
sudo systemctl start tailscaled

echo -e "${GREEN}✅ Services configured${NC}"

# GTK theme
echo ""
echo -e "${YELLOW}🎨 Setting up GTK theme...${NC}"
mkdir -p ~/.config/gtk-3.0

cat > ~/.config/gtk-3.0/gtk.css << 'EOF'
/* Calendar styling */
calendar {
    background-color: rgba(32, 17, 28, 0.95);
    color: #FEE5E4;
    border: 3px solid #EF3946;
    border-radius: 10px;
    padding: 20px;
    font-size: 14px;
}

calendar.header {
    background-color: rgba(239, 57, 70, 0.3);
    color: #FEE5E4;
    padding: 15px;
    font-size: 16px;
    font-weight: bold;
}

calendar:selected {
    background-color: #EF3946;
    color: #FFFFFF;
    border-radius: 5px;
}

calendar.button {
    color: #FEE5E4;
    padding: 10px;
}

calendar.button:hover {
    background-color: rgba(239, 57, 70, 0.5);
}
EOF

echo -e "${GREEN}✅ GTK theme configured${NC}"

# Sudoers for remote control
echo ""
echo -e "${YELLOW}🔐 Configuring sudoers for remote control...${NC}"
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/shutdown" | sudo tee /etc/sudoers.d/remote-control > /dev/null
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/reboot" | sudo tee -a /etc/sudoers.d/remote-control > /dev/null
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl suspend" | sudo tee -a /etc/sudoers.d/remote-control > /dev/null
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl poweroff" | sudo tee -a /etc/sudoers.d/remote-control > /dev/null
sudo chmod 440 /etc/sudoers.d/remote-control

echo -e "${GREEN}✅ Sudoers configured${NC}"

# Final message
echo ""
echo "=========================================="
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Logout and select 'Hyprland' from your login manager"
echo "2. Set up Tailscale: sudo tailscale up"
echo "3. Configure OpenRGB profile in GUI"
echo ""
echo "Keybindings:"
echo "  Super + Return - Terminal"
echo "  Super + D - App launcher"
echo "  Super + B - Firefox"
echo "  Super + M - Music visualizer"
echo ""
echo "Remote access:"
echo "  SSH: ssh -p 2222 $USER@<your-ip>"
echo "  Tailscale: ssh -p 2222 $USER@<tailscale-ip>"
echo ""
echo "Your old configs are backed up in: $BACKUP_DIR"
echo "=========================================="
