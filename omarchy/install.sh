#!/usr/bin/env bash
set -eou pipefail

PACKAGES=(
    diff-so-fancy
    fzf
    git
    go
    go-task
    golangci-lint
    jq
    starship
    uv
    yq
    zsh
)

function install_packages () {
    echo "Installing packages..."
    sudo pacman -Syu --needed "${PACKAGES[@]}"
    echo "Done installing packages."
}

function setup_dotfiles () {
    local dotfiles_dir="$HOME/.dotfiles"
    local omarchy_dir="$dotfiles_dir/omarchy"

    echo "Setting up dotfiles from $omarchy_dir..."

    # zshrc
    local zshrc_target="$HOME/.zshrc"
    if [ -e "$zshrc_target" ] && [ ! -h "$zshrc_target" ]; then
        echo "$zshrc_target already exists. Moving to $zshrc_target.bak"
        mv "$zshrc_target" "$zshrc_target.bak"
    fi
    ln -sf "$omarchy_dir/_zshrc" "$zshrc_target"

    # hyprland input overrides (caps lock -> ctrl, touchpad, etc.)
    mkdir -p "$HOME/.config/hypr"
    local hypr_input_target="$HOME/.config/hypr/input.conf"
    if [ -e "$hypr_input_target" ] && [ ! -h "$hypr_input_target" ]; then
        echo "$hypr_input_target already exists. Moving to $hypr_input_target.bak"
        mv "$hypr_input_target" "$hypr_input_target.bak"
    fi
    ln -sf "$omarchy_dir/_hypr-input.conf" "$hypr_input_target"

    # gitconfig (omarchy-specific: nvim editor, linux paths)
    local gitconfig_target="$HOME/.gitconfig"
    if [ -e "$gitconfig_target" ] && [ ! -h "$gitconfig_target" ]; then
        echo "$gitconfig_target already exists. Moving to $gitconfig_target.bak"
        mv "$gitconfig_target" "$gitconfig_target.bak"
    fi
    ln -sf "$omarchy_dir/_gitconfig" "$gitconfig_target"

    # gitignore (shared, lives in parent dotfiles dir)
    local gitignore_target="$HOME/.gitignore"
    if [ -e "$gitignore_target" ] && [ ! -h "$gitignore_target" ]; then
        echo "$gitignore_target already exists. Moving to $gitignore_target.bak"
        mv "$gitignore_target" "$gitignore_target.bak"
    fi
    ln -sf "$dotfiles_dir/_gitignore" "$gitignore_target"

    # gnupg config (shared, lives in parent dotfiles dir)
    mkdir -p "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
    for f in gpg.conf gpg-agent.conf scdaemon.conf; do
        local gnupg_target="$HOME/.gnupg/$f"
        if [ -e "$gnupg_target" ] && [ ! -h "$gnupg_target" ]; then
            echo "$gnupg_target already exists. Moving to $gnupg_target.bak"
            mv "$gnupg_target" "$gnupg_target.bak"
        fi
        ln -sf "$dotfiles_dir/shared/_gnupg/$f" "$gnupg_target"
    done

    echo "Done setting up dotfiles."
}

function setup_dirs () {
    mkdir -p "$HOME/.bin"
    mkdir -p "$HOME/personal"
}

function main () {
    install_packages
    setup_dirs
    setup_dotfiles
}

main
