#!/usr/bin/env bash

# shellcheck disable=SC2164
cd "$DOTFILESDIRREL/.."

# Function to install the dotfile to ~ only when changes are detected.
function install_dotfiles() {
    rsync --exclude ".git/" \
        --exclude "script/" \
        --exclude ".DS_Store" \
        --exclude ".macos" \
        --exclude "brew.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~
    # shellcheck disable=SC1090
    source ~/.bash_profile;
}

# Confirm with the user that proceeding to install the dotfiles can be
# destructive.
if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    log "Installing dotfiles to ~"
    install_dotfiles
    success "dotfiles successfully installed!"
else
    log "Installing dotfiles to ~ may overwrite existing files in your home directory. Are you sure? [y/N]"
    read -r

    if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      log "Proceeding with installing dotfiles to ~"
      install_dotfiles
      success "dotfiles successfully installed!"
    else
      error "Skipping installing dotfiles."
    fi
fi

unset install_dotfiles

# shellcheck disable=SC2164
cd "$DOTFILESDIRREL"
