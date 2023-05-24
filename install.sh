#!/usr/bin/env bash
set -e -ou pipefail

PACKAGES=(
    asdf
    awscli
    base64
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
    intel-power-gadget
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

VSCODE_EXTENTIONS=(
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

function install_prereqs () {
    echo "Installing prereqs"
    # xcode tools needed for homebrew
    xcode-select --install

    # homebrew, used for everything else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Done installing prereqs"
}

function install_packages () {
    echo "Installing homebrew packages..."
    brew update && brew install "${PACKAGES[@]}"

    /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
    echo "Done install homebrew packages."

    echo "Installing VS Code Extentions..."
    for ext in ${VSCODE_EXTENTIONS[@]}; do
        code --force --install-extension "$ext"
    done
    echo "Done installing VS Code Extentions"

    echo "Install asdf plugins..."
    . $(brew --prefix)/opt/asdf/libexec/asdf.sh
    asdf plugin add python
    asdf plugin add terraform
    echo "Done installing asdf plugins."
}

function install_applications () {
    echo "Installing homebrew applications..."
    brew tap homebrew/cask-drivers \
      && brew update \
      && brew install --cask "${CASKS[@]}"
    echo "Done installing homebrew applications."
}

function setup_shell () {
    echo "Setting up powerline-go ..."
    go install github.com/justjanne/powerline-go@latest
    git clone https://github.com/powerline/fonts.git --depth=1 "$HOME/fonts"
    "$HOME/fonts/install.sh"
    rm -r "$HOME/fonts"
    echo "Done setting up powerline-go."
}

function setup_python () {
    echo "Setting up poetry ..."
    curl -sSL https://install.python-poetry.org | python -
    echo "Done setting up poetry."
}

function setup_dotfiles () {
    # setup homedir dotfiles
    git clone https://github.com/ianlofs/dotfiles.git "$HOME/.dotfiles"
    for i in "$HOME/.dotfiles/_*"; do
        source="${HOME}/.dotfiles/$i"
        target="${HOME}/${i/_/.}"

        # everything else gets symlinked into home dir
        if [ -e "${target}" ] && [ -h "${target}" ]; then
            backup="${HOME}/.save.${i}"
            echo "${target} already exists. Moving to ${backup}"
            mv "${target}" "${backup}"
        fi
        ln -s "$source" "$target"
    done

    # kitty terminal conf
    ln -s "${HOME}/.dotfiles/kitty.conf" "$HOME/.config/kitty/kitty.conf"

    # vs code editor conf
    ln -s "$HOME/.dotfiles/vscode_settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
}

function setup_dirs () {
    mkdir "$HOME/.bin"
    mkdir "$HOME/circleci"
    mkdir "$HOME/personal"
}

function main () {
    install_prereqs
    install_packages
    install_applications

    setup_shell
    setup_python
    setup_dirs
    setup_dotfiles
    setup_prodtools
}

main
