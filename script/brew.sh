#!/usr/bin/env bash
#
# Install command-line tools and applications using Homebrew.

log_info "Setting up Homebrew"

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

install_homebrew() {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

update_homebrew() {
    brew update

    # The Travis build servers come with a lot of pre-installed Brew formulas,
    # let's not go and upgrade them all.
    if [[ $TRAVIS_CI != "1" ]]; then
        brew upgrade
    fi
}

cleanup_homebrew() {
    brew cleanup
}

install_homebrew_formulae() {
    brew bundle install --global
}

configure_brew_installed_apps() {
    # Install VS Code extensions.
    EXTENSIONS="$(code --list-extensions)"

    grep -v '^ *#' < "$(dirname "$0")"/../vscode/vscode-extensions | while IFS= read -r EXTENSION
    do
        if echo "$EXTENSIONS" | grep -q "$EXTENSION"; then
            echo "Extension '$EXTENSION' is already installed."
        else
            code --install-extension "$EXTENSION"
        fi
    done

    # Configure VS Code settings.
    cp "$(dirname "$0")"/../vscode/settings.json "$HOME"/Library/Application\ Support/Code/User/settings.json
}

install_brewfile() {
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
log_info "Checking if Homebrew is installed."
if test ! "$(command -v brew)"; then
    if [[ ${FORCE} -eq 1 ]]; then
        log_info "Installing Homebrew"
        install_homebrew
        update_homebrew
        cleanup_homebrew
        log_success "Homebrew successfully installed!"
        log_info "Installing Homebrew formulae"
        install_homebrew_formulae
        cleanup_homebrew
        configure_brew_installed_apps
        log_success "Homebrew formulae successfully installed!"
    else
        log_info "Homebrew is required to continue with the setup of your dotfiles. Would you like to install Homebrew? [y/N]"
        read -r

        if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            log_info "Proceeding with installing Homebrew"
            install_homebrew
            update_homebrew
            cleanup_homebrew
            log_success "Homebrew successfully installed!"
            log_info "Installing Homebrew formulae"
            install_homebrew_formulae
            cleanup_homebrew
            configure_brew_installed_apps
            log_success "Homebrew formulae successfully installed!"
        else
            log_error "Homebrew is required to proceed with the installation of your dotfiles"
            exit 1
        fi
    fi
else
    log_success "Homebrew is already installed!"

    if [[ ${FORCE} -eq 1 ]]; then
        update_homebrew
        log_info "Installing Homebrew formulae"
        install_homebrew_formulae
        cleanup_homebrew
        configure_brew_installed_apps
        log_success "Homebrew formulae successfully installed!"
    else
        log_info "Would you like Homebrew to also install the taps, packages and applications found in ~/.Brewfile? [y/N]"
        read -r

        if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            update_homebrew
            log_info "Proceeding with installing Homebrew formulae"
            install_homebrew_formulae
            cleanup_homebrew
            configure_brew_installed_apps
            log_success "Homebrew formulae successfully installed!"
        else
            log_warn "Skipping installing Homebrew formulae. Note this may cause issues if you are missing any packages that are referred to in your dotfiles."
        fi
    fi
fi

unset install_homebrew
unset update_homebrew
unset cleanup_homebrew
unset install_homebrew_formulae
unset configure_brew_installed_apps
unset install_brewfile
