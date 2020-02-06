#!/usr/bin/env bash
#
# Install dotfiles to home directory.

log_info "== DOTFILES =="

# Function to install the dotfiles to ~ only when changes are detected. Brewfile
# is already installed in brew.sh so we won't install it again here. I also
# rename the files to prepend the "." (dot) when they are synced to ~. The
# reason I don't store them in the git repo with the dot is so that it is easier
# to manage repo specific dotfiles like .gitignore etc.
install_dotfiles() {
  log_info "Installing dotfiles to root..."

  dotfiles_arr=(gitconfig gitignore hushlogin vimrc zprofile zshrc)
  dotfolders_arr=(gnupg ssh)

  pushd dotfiles > /dev/null || exit

  for file in "${dotfiles_arr[@]}"; do
    if [ -r "$file" ] && [ -f "$file" ]; then
      rsync -avh --no-perms --quiet "$file" ~/."$file"
    fi
  done

  for folder in "${dotfolders_arr[@]}"; do
    if [ -d "$folder" ]; then
      rsync -avh --no-perms --quiet "$folder"/ ~/."$folder"
    fi
  done

  popd > /dev/null || exit

  log_success "Dotfiles successfully installed!"
}

# Confirm with the user that proceeding to install the dotfiles can be
# destructive.
if [[ ${FORCE} -ne 1 ]]; then
  log_info "Installing dotfiles to root may overwrite existing files in your home directory. Are you sure? [y/N]"
  read -r
fi

if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ || ${FORCE} -eq 1 ]]; then
    install_dotfiles
else
  log_warn "Skipping installing dotfiles!"
fi

unset install_dotfiles
