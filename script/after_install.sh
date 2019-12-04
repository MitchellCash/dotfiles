#!/usr/bin/env bash
#
# After setting up dotfiles, macOS and Homebrew complete the final
# system configurations and ask to reboot the system.

log_info "== FINAL CONFIGURATIONS =="

# Configure Visual Studio Code.
configure_vscode() {
  if ! command -v code > /dev/null; then
    log_warn "Visual Studio Code is not installed, skipping configuration"
  else
    readonly EXTENSIONS="$(code --list-extensions)"

    log_info "Configuring Visual Studio Code..."

    # Install Visual Studio Code extensions.
    while IFS= read -r EXTENSION; do
      if echo "${EXTENSIONS}" | grep -q "${EXTENSION}"; then
        log_warn "Visual Studio Code extension ${EXTENSION} is already installed!"
      else
        log_info "Installing Visual Studio Code extension ${EXTENSION}.."
        code --install-extension "${EXTENSION}"
      fi
    done < "${DOTFILESDIRREL}"/vscode/vscode-extensions

    # Configure Visual Studio Code settings.
    cp "${DOTFILESDIRREL}"/vscode/settings.json "${HOME}"/Library/Application\ Support/Code/User/settings.json

    log_success "Visual Studio Code successfully configured!"
fi
}

# Link 'spaceship.zsh' to 'prompt_spaceship_setup' and inside .zshrc we add the
# .dotfiles/terminal-theme dir to $fpath so we can use the theme with
# 'prompt spaceship'. We do the linking because we want the filename to begin
# with prompt_* as expected by the Zsh function 'promptinit'.
# See: https://github.com/denysdovhan/spaceship-prompt#manual
setup_spaceship_prompt() {
  if [[ "${CI}" -ne 1 ]]; then
    log_info "Installing Spaceship Zsh prompt theme..."

    if [[ ! -d "${HOME}/.terminal/zsh-prompt-themes/spaceship-prompt" ]]; then
      git clone --quiet https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.terminal/zsh-prompt-themes/spaceship-prompt"
    fi

    ln -sf "${HOME}/.terminal/zsh-prompt-themes/spaceship-prompt/spaceship.zsh" "${HOME}/.terminal/zsh-prompt-themes/prompt_spaceship_setup"

    log_success "Spaceship prompt theme successfully installed!"
  fi
}

# Use the One Dark colour theme by default in Terminal.app. We also export
# 'CLICOLOR' and 'LSCOLORS' inside .zshrc as per:
#  https://github.com/nathanbuchar/atom-one-dark-terminal/blob/master/README.md
setup_one_dark_terminal() {
  if [[ "${CI}" -ne 1 ]]; then
    log_info "Installing One Dark Terminal theme..."
    log_info "While this installs additional Terminal windows will open and close"

    if [[ ! -d "${HOME}/.terminal/terminal-themes/atom-one-dark-terminal" ]]; then
      git clone --quiet https://github.com/nathanbuchar/atom-one-dark-terminal.git "${HOME}/.terminal/terminal-themes/atom-one-dark-terminal"
    fi

osascript <<EOD
tell application "Terminal"
  set custom title of every window to "alreadyOpenedTerminalWindows"
  do shell script "open '${HOME}/.dotfiles/terminal-theme/atom-one-dark-terminal/scheme/terminal/One Dark.terminal'"
  do shell script "sleep 10"
  do shell script "defaults write com.apple.Terminal 'Default Window Settings' -string 'One Dark'"
  do shell script "defaults write com.apple.Terminal 'Startup Window Settings' -string 'One Dark'"
  close (every window whose name does not contain "alreadyOpenedTerminalWindows")
end tell
EOD

  log_success "One Dark Terminal theme successfully installed!"
  fi
}

# Switch to Z shell. This requires the user to input their password.
chsh_zsh() {
  if [[ "${CI}" -ne 1 ]]; then
    if [ "${SHELL}" != "/bin/zsh" ]; then
      log_info "Changing shell to Z shell, this requires a password..."
      chsh -s /bin/zsh
      log_success "Shell successfully changed!"
    fi
  fi
}

log_info "Running final configurations..."
configure_vscode
setup_spaceship_prompt
setup_one_dark_terminal
chsh_zsh
log_success "Your system has now been successfully setup!"
