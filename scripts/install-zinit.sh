#!/bin/bash

# Zinit Installation Script
# This script installs Zinit (ZSH plugin manager) if not already installed

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Zinit installation directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if Zinit is already installed
check_zinit_installed() {
    if [[ -d "$ZINIT_HOME" ]] && [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if required commands exist
check_requirements() {
    local missing_commands=()
    
    if ! command -v git >/dev/null 2>&1; then
        missing_commands+=("git")
    fi
    
    if ! command -v zsh >/dev/null 2>&1; then
        missing_commands+=("zsh")
    fi
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        print_status "$RED" "Error: Missing required commands: ${missing_commands[*]}"
        print_status "$YELLOW" "Please install the missing commands and try again."
        return 1
    fi
    
    return 0
}

# Function to install Zinit
install_zinit() {
    print_status "$BLUE" "Installing Zinit..."
    
    # Create Zinit directory
    if ! mkdir -p "$(dirname "$ZINIT_HOME")"; then
        print_status "$RED" "Error: Failed to create Zinit directory"
        return 1
    fi
    
    # Clone Zinit repository
    if ! git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
        print_status "$RED" "Error: Failed to clone Zinit repository"
        return 1
    fi
    
    print_status "$GREEN" "Zinit installed successfully to $ZINIT_HOME"
    return 0
}

# Function to update .zshrc with Zinit configuration
update_zshrc() {
    local zshrc_file="$HOME/.zshrc"
    local zinit_marker="# Added by Zinit installer"
    
    # Check if Zinit configuration is already present
    if [[ -f "$zshrc_file" ]] && grep -q "$zinit_marker" "$zshrc_file"; then
        print_status "$YELLOW" "Zinit configuration already exists in .zshrc"
        return 0
    fi
    
    print_status "$BLUE" "Adding Zinit configuration to .zshrc..."
    
    # Backup .zshrc if it exists
    if [[ -f "$zshrc_file" ]]; then
        cp "$zshrc_file" "${zshrc_file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "$YELLOW" "Backup created: ${zshrc_file}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Add Zinit configuration to .zshrc
    cat >> "$zshrc_file" << 'EOF'

# Added by Zinit installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load completions
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
EOF
    
    print_status "$GREEN" "Zinit configuration added to .zshrc"
    return 0
}

# Main installation function
main() {
    print_status "$BLUE" "=== Zinit Installation Script ==="
    
    # Check requirements
    if ! check_requirements; then
        exit 1
    fi
    
    # Check if Zinit is already installed
    if check_zinit_installed; then
        print_status "$YELLOW" "Zinit is already installed at $ZINIT_HOME"
        print_status "$BLUE" "Checking .zshrc configuration..."
        
        # Still try to update .zshrc in case configuration is missing
        if update_zshrc; then
            print_status "$GREEN" "Zinit setup completed successfully!"
        else
            print_status "$RED" "Error: Failed to update .zshrc"
            exit 1
        fi
    else
        # Install Zinit
        if install_zinit; then
            # Update .zshrc
            if update_zshrc; then
                print_status "$GREEN" "Zinit installation completed successfully!"
                print_status "$YELLOW" "Please restart your shell or run 'source ~/.zshrc' to use Zinit."
            else
                print_status "$RED" "Error: Zinit installed but failed to update .zshrc"
                exit 1
            fi
        else
            print_status "$RED" "Error: Zinit installation failed"
            exit 1
        fi
    fi
    
    print_status "$BLUE" "=== Installation Complete ==="
}

# Run the script only if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi