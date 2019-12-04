#!/usr/bin/env bash
#
# Install command-line tools and applications using Homebrew.

log_info "== HOMEBREW =="

setup_brewfile() {
  log_info "Syncing Brewfile to root..."
  rsync -avh --no-perms .dotfiles/Brewfile ~/.Brewfile

  # Remove installation of cask and mas applications on Travis as they are
  # likely to fail due to Travis restrictions.
  if [[ "${CI}" -eq 1 ]]; then
    sed -i '' '/cask*/d' ~/.Brewfile
    sed -i '' '/mas*/d' ~/.Brewfile
  fi

  log_success "Brewfile successfully synced!"
}

homebrew_install() {
  log_info "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  log_success "Homebrew successfully installed!"
}

homebrew_update() {
  log_info "Updating Homebrew..."
  brew update

  # The Travis build servers come with a lot of pre-installed Brew formulas,
  # let's not go and upgrade them all.
  if [[ "${CI}" -ne 1 ]]; then
    brew upgrade
  fi

  log_success "Homebrew successfully updated!"
}

homebrew_cleanup() {
  log_info "Cleaning up Homebrew..."
  brew cleanup
  log_success "Homebrew successfully cleaned!"
}

homebrew_install_formulae() {
  log_info "Installing Homebrew formulae..."
  brew bundle install --global
  log_success "Homebrew formulae successfully installed!"
}

# Check if Homebrew is installed and ask to install. If Homebrew is not already
# installed it will also proceed with installing all Homebrew formulae as it
# assumes this is a new system. If Homebrew is already installed, it will ask
# for confirmation from the user.
log_info "Checking if Homebrew is installed..."
if test ! "$(command -v brew)"; then

  if [[ ${FORCE} -ne 1 ]]; then
    log_info "Homebrew is not installed. Would you like to install Homebrew and all formulae in the Brewfile? [y/N]"
    read -r
  fi

  if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ || ${FORCE} -eq 1 ]]; then
    setup_brewfile
    homebrew_install
    homebrew_update
    homebrew_install_formulae
    homebrew_cleanup
  else
    log_warn "Skipping Homebrew install! This may cause issues if you are missing any packages referred to in your dotfiles!"
    return
  fi
else
  log_success "Homebrew is already installed!"

  if [[ ${FORCE} -ne 1 ]]; then
    log_info "Would you like Homebrew to also install the formulae found in the Brewfile? [y/N]"
    read -r
  fi

  if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ || ${FORCE} -eq 1 ]]; then
    setup_brewfile
    homebrew_update
    homebrew_install_formulae
    homebrew_cleanup
  else
    log_warn "Skipping installing Homebrew formulae! This may cause issues if you are missing any packages referred to in your dotfiles!"
  fi
fi

unset homebrew_install
unset homebrew_update
unset homebrew_cleanup
unset homebrew_install_formulae
unset setup_brewfile
