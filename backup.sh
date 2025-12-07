#!/bin/bash

echo "=========================================="
echo "  M-Hypr-Config Backup Script"
echo "=========================================="
echo ""

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Copy configs
echo "📦 Backing up configurations..."
cp -r ~/.config/hypr/* configs/hypr/
cp -r ~/.config/waybar/* configs/waybar/
cp -r ~/.config/rofi/* configs/rofi/
cp -r ~/.config/kitty/* configs/kitty/
cp -r ~/.config/cava/* configs/cava/
cp -r ~/.config/OpenRGB/*.orp configs/OpenRGB/ 2>/dev/null

# Copy scripts
echo "📝 Backing up scripts..."
cp -r ~/.local/bin/* scripts/

# Copy wallpapers
echo "🖼️  Backing up wallpapers..."
cp ~/Pictures/Wallpapers/* wallpapers/ 2>/dev/null

# Update package lists
echo "📋 Updating package lists..."
pacman -Qqe > packages-explicit.txt
pacman -Qqm > packages-aur.txt

# Git operations
echo ""
read -p "📝 Enter commit message: " commit_msg

if [ -z "$commit_msg" ]; then
    commit_msg="Update configs - $(date +%Y-%m-%d)"
fi

echo ""
echo "🔄 Committing changes..."
git add .
git commit -m "$commit_msg"

echo ""
read -p "🚀 Push to GitHub? (y/n): " push_choice

if [ "$push_choice" = "y" ]; then
    git push
    echo "✅ Backup complete and pushed to GitHub!"
else
    echo "✅ Backup complete! (Not pushed)"
fi

echo ""
echo "=========================================="
