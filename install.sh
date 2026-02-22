#!/usr/bin/env bash
set -eou pipefail

DOTFILES_REPO="https://github.com/ianlofs/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

function detect_platform () {
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]] && grep -q "omarchy\|arch" /etc/os-release; then
        echo "omarchy"
    else
        echo "unknown"
    fi
}

function ensure_macos_prereqs () {
    # Xcode Command Line Tools (provides git, make, etc.)
    if ! xcode-select -p &>/dev/null; then
        echo "Installing Xcode Command Line Tools..."
        xcode-select --install
        echo "Please complete the Xcode Command Line Tools installation dialog, then re-run this script."
        exit 0
    fi

    # Homebrew
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

function ensure_prereqs () {
    local platform="$1"
    case "$platform" in
        macos)
            ensure_macos_prereqs
            ;;
        omarchy)
            if ! command -v git &>/dev/null; then
                echo "Installing git..."
                sudo pacman -Sy --needed git
            fi
            ;;
    esac
}

function ensure_repo () {
    if [ -d "$DOTFILES_DIR/.git" ]; then
        echo "Dotfiles already cloned at $DOTFILES_DIR."
    else
        echo "Cloning dotfiles to $DOTFILES_DIR..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        echo "Done cloning."
    fi
}

function main () {
    local platform
    platform="$(detect_platform)"

    if [[ "$platform" == "unknown" ]]; then
        echo "Unknown platform. Supported platforms: macOS, Omarchy (Arch Linux)."
        echo "Run the platform-specific install script directly:"
        echo "  macOS:   $DOTFILES_DIR/macos/install.sh"
        echo "  Omarchy: $DOTFILES_DIR/omarchy/install.sh"
        exit 1
    fi

    ensure_prereqs "$platform"
    ensure_repo

    case "$platform" in
        macos)
            echo "Detected macOS. Running macOS install..."
            "$DOTFILES_DIR/macos/install.sh"
            ;;
        omarchy)
            echo "Detected Omarchy/Arch. Running Omarchy install..."
            "$DOTFILES_DIR/omarchy/install.sh"
            ;;
    esac
}

main
