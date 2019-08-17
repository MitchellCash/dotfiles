#!/usr/bin/env bash
#
# Install dotfiles to home directory.

log_info "Setting up dotfiles"

# Function to install the dotfiles to ~ only when changes are detected. Brewfile
# is already installed in brew.sh so we won't install it again here. I also
# rename the files to prepend the "." (dot) when they are synced to ~. The
# reason I don't store them in the git repo with the dot is so that it is easier
# to manage repo specific dotfiles like .gitignore etc.
function install_dotfiles() {
    cd .dotfiles || exit
    for file in {zprofile,zshrc,gitconfig,gitignore,hushlogin}; do
        if [ -r "$file" ] && [ -f "$file" ]; then
            rsync -avh --no-perms $file ~/.$file
        fi
    done
    cd .. || exit

    for folder in {gnupg,ssh,terminal-theme}; do
        if [ -d ".$folder" ]; then
            rsync -avh --no-perms .$folder/ ~/.$folder
        fi
    done
}

# Confirm with the user that proceeding to install the dotfiles can be
# destructive.
if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    log_info "Installing dotfiles to ~"
    install_dotfiles
    log_success "dotfiles successfully installed!"
else
    log_info "Installing dotfiles to ~ may overwrite existing files in your home directory. Are you sure? [y/N]"
    read -r

    if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      log_info "Proceeding with installing dotfiles to ~"
      install_dotfiles
      log_success "dotfiles successfully installed!"
    else
      log_warn "Skipping installing dotfiles"
    fi
fi

unset install_dotfiles
