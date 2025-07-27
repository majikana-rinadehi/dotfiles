#!/bin/bash

# Automatic dependency installation script
# Supports macOS (Homebrew), Ubuntu/Debian (apt), CentOS/RHEL (yum/dnf)

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to detect platform and package manager
detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            echo "macOS"
            ;;
        Linux*)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian)
                        echo "ubuntu"
                        ;;
                    centos|rhel|fedora)
                        echo "centos"
                        ;;
                    *)
                        echo "linux"
                        ;;
                esac
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unsupported"
            ;;
    esac
}

# Function to detect available package manager
detect_package_manager() {
    local platform=$1
    
    case "$platform" in
        macOS)
            if command -v brew >/dev/null 2>&1; then
                echo "brew"
            else
                echo "none"
            fi
            ;;
        ubuntu)
            if command -v apt >/dev/null 2>&1; then
                echo "apt"
            elif command -v apt-get >/dev/null 2>&1; then
                echo "apt-get"
            else
                echo "none"
            fi
            ;;
        centos)
            if command -v dnf >/dev/null 2>&1; then
                echo "dnf"
            elif command -v yum >/dev/null 2>&1; then
                echo "yum"
            else
                echo "none"
            fi
            ;;
        *)
            echo "none"
            ;;
    esac
}

# Function to install Homebrew on macOS
install_homebrew() {
    print_status "$BLUE" "Installing Homebrew..."
    
    # Check if running in CI or non-interactive environment
    if [[ -n "${CI:-}" ]] || [[ ! -t 0 ]]; then
        print_status "$YELLOW" "Running in non-interactive environment. Skipping Homebrew installation."
        print_status "$YELLOW" "Please install Homebrew manually: https://brew.sh"
        return 1
    fi
    
    # Install Homebrew
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        print_status "$GREEN" "Homebrew installed successfully!"
        
        # Add Homebrew to PATH for current session
        case "$(uname -m)" in
            arm64)
                export PATH="/opt/homebrew/bin:$PATH"
                ;;
            x86_64)
                export PATH="/usr/local/bin:$PATH"
                ;;
        esac
        
        return 0
    else
        print_status "$RED" "Failed to install Homebrew"
        return 1
    fi
}

# Function to update package manager
update_package_manager() {
    local platform=$1
    local pkg_manager=$2
    
    print_status "$BLUE" "Updating package manager..."
    
    case "$pkg_manager" in
        apt|apt-get)
            sudo "$pkg_manager" update
            ;;
        dnf|yum)
            sudo "$pkg_manager" check-update || true  # yum check-update returns 100 if updates available
            ;;
        brew)
            brew update
            ;;
        *)
            print_status "$YELLOW" "Unknown package manager: $pkg_manager"
            return 1
            ;;
    esac
}

# Function to install package
install_package() {
    local platform=$1
    local pkg_manager=$2
    local package=$3
    
    print_status "$BLUE" "Installing $package..."
    
    case "$pkg_manager" in
        apt|apt-get)
            sudo "$pkg_manager" install -y "$package"
            ;;
        dnf)
            sudo dnf install -y "$package"
            ;;
        yum)
            sudo yum install -y "$package"
            ;;
        brew)
            brew install "$package"
            ;;
        *)
            print_status "$RED" "Unknown package manager: $pkg_manager"
            return 1
            ;;
    esac
}

# Function to check if package is installed
is_package_installed() {
    local command_name=$1
    command -v "$command_name" >/dev/null 2>&1
}

# Function to install required dependencies
install_dependencies() {
    local platform=$1
    local required_packages=("git" "curl" "zsh")
    
    print_status "$BLUE" "=== Installing Dependencies ==="
    print_status "$BLUE" "Platform: $platform"
    
    # Detect package manager
    local pkg_manager
    pkg_manager=$(detect_package_manager "$platform")
    
    if [[ "$pkg_manager" == "none" ]]; then
        case "$platform" in
            macOS)
                print_status "$YELLOW" "Homebrew not found. Attempting to install..."
                if install_homebrew; then
                    pkg_manager="brew"
                else
                    print_status "$RED" "Failed to install Homebrew. Please install manually: https://brew.sh"
                    return 1
                fi
                ;;
            *)
                print_status "$RED" "No supported package manager found for platform: $platform"
                return 1
                ;;
        esac
    fi
    
    print_status "$BLUE" "Package manager: $pkg_manager"
    
    # Update package manager
    if ! update_package_manager "$platform" "$pkg_manager"; then
        print_status "$YELLOW" "Failed to update package manager, continuing anyway..."
    fi
    
    # Install missing packages
    local missing_packages=()
    for package in "${required_packages[@]}"; do
        if ! is_package_installed "$package"; then
            missing_packages+=("$package")
        fi
    done
    
    if [[ ${#missing_packages[@]} -eq 0 ]]; then
        print_status "$GREEN" "All required packages are already installed!"
        return 0
    fi
    
    print_status "$YELLOW" "Missing packages: ${missing_packages[*]}"
    
    # Install missing packages
    for package in "${missing_packages[@]}"; do
        if install_package "$platform" "$pkg_manager" "$package"; then
            print_status "$GREEN" "$package installed successfully!"
        else
            print_status "$RED" "Failed to install $package"
            return 1
        fi
    done
    
    print_status "$GREEN" "All dependencies installed successfully!"
    return 0
}

# Main function
main() {
    print_status "$BLUE" "=== Automatic Dependency Installation ==="
    
    local platform
    platform=$(detect_platform)
    
    if [[ "$platform" == "unsupported" ]]; then
        print_status "$RED" "Unsupported platform: $(uname -s)"
        exit 1
    fi
    
    if install_dependencies "$platform"; then
        print_status "$GREEN" "=== Installation Complete ==="
        exit 0
    else
        print_status "$RED" "=== Installation Failed ==="
        exit 1
    fi
}

# Run the script only if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi