#!/usr/bin/env bash
# Install command-line tools and applications using Homebrew.

log "Setting up Homebrew"

function install_homebrew() {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function update_homebrew() {
    brew update
    brew upgrade
}

function cleanup_homebrew() {
    brew cleanup
}

function install_homebrew_formulae() {
    brew bundle install --global
}

function brew_installed_bash() {
    # Switch to using brew-installed bash as default shell. Don't change shell on
    # Travis CI.
    if [[ $TRAVIS_CI != "1" ]]; then
        if ! grep -Fq '/usr/local/bin/bash' /etc/shells; then
            echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
            chsh -s /usr/local/bin/bash;
        fi
    fi
}

function install_brewfile() {
    rsync -avh --no-perms .dotfiles/Brewfile ~/.Brewfile
    # Remove installation of cask and mas applications on Travis as they are
    # likely to fail due to Travis restrictions.
    if [[ $TRAVIS_CI = "1" ]]; then
        sed -i '' '/cask*/d' ~/.Brewfile
        sed -i '' '/mas*/d' ~/.Brewfile
    fi
}
install_brewfile

# Check if Homebrew is installed and ask to install. If Homebrew is not already
# installed it will also proceed with installing all Homebrew formulae as it
# assumes this is a new system. If Homebrew is already installed, it will ask
# for confirmation from the user.
log "Checking if Homebrew is installed."
if test ! "$(command -v brew)"; then
    if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
        log "Installing Homebrew"
        install_homebrew
        update_homebrew
        cleanup_homebrew
        success "Homebrew successfully installed!"
        log "Installing Homebrew formulae"
        install_homebrew_formulae
        cleanup_homebrew
        brew_installed_bash
        success "Homebrew formulae successfully installed!"
    else
        log "Homebrew is required to continue with the setup of your dotfiles. Would you like to install Homebrew? [y/N]"
        read -r

        if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            log "Proceeding with installing Homebrew"
            install_homebrew
            update_homebrew
            cleanup_homebrew
            success "Homebrew successfully installed!"
            log "Installing Homebrew formulae"
            install_homebrew_formulae
            cleanup_homebrew
            brew_installed_bash
            success "Homebrew formulae successfully installed!"
        else
            abort "Homebrew is required to proceed with the installation of your dotfiles"
        fi
    fi
else
    success "Homebrew is already installed!"

    if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
        log "Installing Homebrew formulae"
        install_homebrew_formulae
        cleanup_homebrew
        brew_installed_bash
        success "Homebrew formulae successfully installed!"
    else
        log "Would you like Homebrew to also install the taps, packages and applications found in ~/.Brewfile? [y/N]"
        read -r

        if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            log "Proceeding with installing Homebrew formulae"
            install_homebrew_formulae
            cleanup_homebrew
            brew_installed_bash
            success "Homebrew formulae successfully installed!"
        else
            error "Skipping installing Homebrew formulae. Note this may cause issues if you are missing any packages that are referred to in your dotfiles."
        fi
    fi
fi

unset install_homebrew
unset update_homebrew
unset cleanup_homebrew
unset install_homebrew_formulae
unset brew_installed_bash
unset install_brewfile
