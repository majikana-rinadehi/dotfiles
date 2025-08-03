#!/bin/bash

# iTerm2 Setup Script
# This script installs iTerm2 and configures it with custom settings

set -e

echo "Setting up iTerm2..."

# Install iTerm2 if not already installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

# Install iTerm2
if ! brew list --cask iterm2 &> /dev/null; then
    echo "Installing iTerm2..."
    brew install --cask iterm2
else
    echo "iTerm2 is already installed."
fi

# Create iTerm2 preferences directory if it doesn't exist
ITERM2_PREFS_DIR="$HOME/Library/Preferences"
if [ ! -d "$ITERM2_PREFS_DIR" ]; then
    mkdir -p "$ITERM2_PREFS_DIR"
fi

# Get the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Copy iTerm2 preferences
echo "Copying iTerm2 preferences..."
cp "$DOTFILES_DIR/iterm2/com.googlecode.iterm2.plist" "$ITERM2_PREFS_DIR/"

# Set iTerm2 to load preferences from custom folder
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"

# Install recommended font (MesloLGS NF)
echo "Installing recommended font (MesloLGS NF)..."
if ! brew list --cask font-meslo-lg-nerd-font &> /dev/null 2>&1; then
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-meslo-lg-nerd-font
else
    echo "MesloLGS NF font is already installed."
fi

echo "iTerm2 setup complete!"
echo ""
echo "Note: You may need to restart iTerm2 for all settings to take effect."
echo "iTerm2 will now load preferences from: $DOTFILES_DIR/iterm2"