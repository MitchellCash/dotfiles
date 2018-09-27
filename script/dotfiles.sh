#!/usr/bin/env bash
# Install dotfiles to home directory.

log "Setting up dotfiles"

# Function to install the dotfiles to ~ only when changes are detected. Brewfile
# is already installed in brew.sh so we won't install it again here. I also
# rename the files to prepend the "." (dot) when they are synced to ~. The
# reason I don't store them in the git repo with the dot is so that it is easier
# to manage repo specific dotfiles like .gitignore etc.
function install_dotfiles() {
    cd .dotfiles || exit
    for file in {bash_profile,bash_prompt,bashrc,gitconfig,gitignore,hushlogin}; do
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
      error "Skipping installing dotfiles"
    fi
fi

unset install_dotfiles
