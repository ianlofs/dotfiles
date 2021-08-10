#!/usr/bin/env bash
set -e -ou pipefail

PACKAGES=(
    go
    python
    pyenv
    cookiecutter
    grep
    gnu-sed
    gnu-tar
    base64
    zsh
    gnu-getopt
    curl
    fzf
    git
    macvim
    readline
    unzip
    gzip
    libpq
    openssl
    yq@3
    helm
    kubectx
    tig
    jq
    minikube
    terraform
    zlib
    awscli
    jpeg
)

CASKS=(
    kitty
    zoom
    slack
    spotify
    visual-studio-code
    1password
    firefox
    gpg-suite
    snowflake-snowsql
    docker
    sizeup
    istat-menus
)

VSCODE_EXTENTIONS = (
    monokai.theme-monokai-pro-vscode
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
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
}

function install_applications () {
    echo "Installing homebrew applications..."
    brew tap homebrew/cask-drivers \
      && brew update \
      && brew install --cask "${CASKS[@]}" \
      && brew install --cask yubico-yubikey-manager
    echo "Done installing homebrew applications."
}

function setup_shell () {
    echo "Setting up powerline-go ..."
    go get -u github.com/justjanne/powerline-go
    git clone https://github.com/powerline/fonts.git "$HOME/fonts"
    "$HOME/fonts/install.sh"
    rm -r "$HOME/fonts/install.sh"
    echo "Done setting up powerline-go."
}

function setup_python () {
    echo "Setting up poetry ..."
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
    echo "Done setting up poetry."
}

function setup_dotfiles () {
    # setup homedir dotfiles
    git clone https://github.com/ianlofs/dotfiles.git "$HOME/.dotfiles"
    for i in .dotfiles/_*; do
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

function setup_prodtools () {
    git clone git@github.com:circleci/prod-tools.git .prod-tools
    ln -s "$HOME/.prod-tools/bin/prod-tools" "$HOME/.bin/prod"
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
