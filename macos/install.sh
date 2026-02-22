#!/usr/bin/env bash
set -eou pipefail

PACKAGES=(
    awscli
    bat
    cookiecutter
    coreutils
    curl
    diff-so-fancy
    fzf
    git
    go
    go-task
    golangci-lint
    gnu-getopt
    gnu-sed
    gnu-tar
    grep
    gzip
    helm
    jq
    kind
    kubectx
    kubernetes-cli
    libffi
    libpq
    libyaml
    macvim
    openssl
    readline
    telnet
    tig
    unzip
    uv
    vault
    yq
    zlib
    zsh
    zsh-autosuggestions
)

CASKS=(
    1password
    1password-cli
    docker
    firefox
    gpg-suite
    kitty
    obsidian
    sizeup
    slack
    snowflake-snowsql
    spotify
    stats
    visual-studio-code
    zoom
)

VSCODE_EXTENSIONS=(
    bierner.markdown-mermaid
    CircleCI.circleci
    dorzey.vscode-sqlfluff
    eamodio.gitlens
    golang.go
    hashicorp.terraform
    innoverio.vscode-dbt-power-user
    monokai.theme-monokai-pro-vscode
    ms-python.isort
    ms-python.python
    ms-python.vscode-pylance
    njpwerner.autodocstring
)

function install_packages () {
    echo "Installing homebrew packages..."
    brew update && brew install "${PACKAGES[@]}"

    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
    echo "Done installing homebrew packages."

    echo "Installing VS Code extensions..."
    for ext in "${VSCODE_EXTENSIONS[@]}"; do
        code --force --install-extension "$ext"
    done
    echo "Done installing VS Code extensions."
}

function install_applications () {
    echo "Installing homebrew applications..."
    brew update && brew install --cask "${CASKS[@]}"
    echo "Done installing homebrew applications."
}

function setup_shell () {
    echo "Setting up powerline-go..."
    go install github.com/justjanne/powerline-go@latest
    git clone https://github.com/powerline/fonts.git --depth=1 "$HOME/fonts"
    "$HOME/fonts/install.sh"
    rm -rf "$HOME/fonts"
    echo "Done setting up powerline-go."
}

function setup_dotfiles () {
    local dotfiles_dir="$HOME/.dotfiles"
    local macos_dir="$dotfiles_dir/macos"

    echo "Setting up dotfiles from $dotfiles_dir..."

    # zshrc
    ln -sf "$macos_dir/_zshrc" "$HOME/.zshrc"

    # gitconfig
    ln -sf "$macos_dir/_gitconfig" "$HOME/.gitconfig"

    # gitignore (shared)
    ln -sf "$dotfiles_dir/_gitignore" "$HOME/.gitignore"

    # vimrc
    ln -sf "$macos_dir/_vimrc" "$HOME/.vimrc"

    # gnupg (shared)
    mkdir -p "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
    for f in gpg.conf gpg-agent.conf scdaemon.conf; do
        ln -sf "$dotfiles_dir/shared/_gnupg/$f" "$HOME/.gnupg/$f"
    done

    # kitty terminal
    mkdir -p "$HOME/.config/kitty"
    ln -sf "$macos_dir/kitty.conf" "$HOME/.config/kitty/kitty.conf"

    # vs code
    ln -sf "$macos_dir/vscode_settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

    echo "Done setting up dotfiles."
}

function setup_dirs () {
    mkdir -p "$HOME/.bin"
    mkdir -p "$HOME/circleci"
    mkdir -p "$HOME/personal"
}

function main () {
    install_packages
    install_applications
    setup_shell
    setup_dirs
    setup_dotfiles
}

main
