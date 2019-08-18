#!/usr/bin/env bash
#
# After setting up dotfiles, macOS and Homebrew complete the final
# system configurations and ask to reboot the system.

# Switch to Z shell. This requires the user to input their password.
if [[ "${CI}" -ne 1 ]]; then
  if [ "$SHELL" != "/bin/zsh" ]; then
    log_info "Changing shell to Z shell, this requires a password"
    chsh -s /bin/zsh
  fi
fi

# Link 'spaceship.zsh' to 'prompt_spaceship_setup' and inside .zshrc we add the
# .dotfiles/terminal-theme dir to $fpath so we can use the theme with
# 'prompt spaceship'. We do the linking because we want the filename to begin
# with prompt_* as expected by the Zsh function 'promptinit'.
# See: https://github.com/denysdovhan/spaceship-prompt#manual
if [[ "${CI}" -ne 1 ]]; then
  if [[ ! -d "${HOME}/.dotfiles/terminal-theme/spaceship-prompt" ]]; then
    log_info "Cloning Spaceship Zsh prompt"
    git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.dotfiles/terminal-theme/spaceship-prompt"
  fi

  log_info "Configuring Zsh to use Spaceship prompt"
  ln -sf "$HOME/.dotfiles/terminal-theme/spaceship-prompt/spaceship.zsh" "$HOME/.dotfiles/terminal-theme/prompt_spaceship_setup"
fi

# Use the One Dark colour theme by default in Terminal.app. We also export
# 'CLICOLOR' and 'LSCOLORS' inside .zshrc as per:
#  https://github.com/nathanbuchar/atom-one-dark-terminal/blob/master/README.md
if [[ "${CI}" -ne 1 ]]; then
  if [[ ! -d "${HOME}/.dotfiles/terminal-theme/atom-one-dark-terminal" ]]; then
    log_info "Cloning Atom One Dark theme"
    git clone https://github.com/nathanbuchar/atom-one-dark-terminal.git "${HOME}/.dotfiles/terminal-theme/atom-one-dark-terminal"
  fi

  log_info "Configuring terminal to use Atom One Dark colour theme"
  log_info "While this configures additional Terminal windows will open and close"
osascript <<EOD
tell application "Terminal"
  set custom title of every window to "alreadyOpenedTerminalWindows"
  do shell script "open '$HOME/.dotfiles/terminal-theme/atom-one-dark-terminal/scheme/terminal/One Dark.terminal'"
  do shell script "sleep 10"
  do shell script "defaults write com.apple.Terminal 'Default Window Settings' -string 'One Dark'"
  do shell script "defaults write com.apple.Terminal 'Startup Window Settings' -string 'One Dark'"
  close (every window whose name does not contain "alreadyOpenedTerminalWindows")
end tell
EOD
fi

# Final success message and ask the user if they would like to restart the
# system. Don't reboot on Travis CI.
if [[ "${CI}" -ne 1 ]]; then
  if [[ ${FORCE} -ne 1 ]]; then
    log_success "Your system has been successfully setup"
    log_info "Some changes will require a reboot to take effect. Would you like to reboot now? [y/N]"
    read -r
  fi

  if [[ ${REPLY} =~ ^([yY][eE][sS]|[yY])+$ ]] || [[ ${FORCE} -eq 1 ]]; then
    log_info "Your system will reboot in 5 seconds."
    sleep 5
    sudo shutdown -r now
  else
    log_info "Skipping system reboot"
    log_warn "Although most things will function without issue, there could be certain undesired effects until the next time you reboot"
  fi
fi
