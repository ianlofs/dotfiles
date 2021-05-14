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
    curl https://raw.githubusercontent.com/powerline/fonts/master/install.sh | bash
    echo "Done setting up powerline-go."
}

function setup_python () {
    echo "Setting up poetry ..."
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
    echo "Done setting up poetry."
}

function setup_dotfiles () {
    # setup homedir dotfiles
    for i in _*; do
        source="${PWD}/$i"
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
    ln -s "${PWD}/kitty.conf" "$HOME/.config/kitty/kitty.conf"
}

function main () {
    install_prereqs
    install_packages
    install_applications
    setup_shell
    setup_python

    # now clone dotfiles repo and
    # setup all the .dotfiles
    git clone https://github.com/ianlofs/dotfiles.git "$HOME/.dotfiles"
    cd .dotfiles
    setup_dotfiles
}

main
