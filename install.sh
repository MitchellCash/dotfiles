#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status (non-zero exit
# status denotes failure).
set -e

# Store relative path as a variable.
readonly DOTFILESDIRREL=$(dirname "$0")

# Store terminal/prompt theme paths.
readonly TERMINAL_THEMES_DIR="${HOME}/.terminal/terminal-themes"
readonly PROMPT_THEMES_DIR="${HOME}/.terminal/zsh-prompt-themes"

# Colors for terminal log outputs.
readonly COL_RESET="\033[00m"
readonly COL_BOLD="\033[01m"
readonly COL_RED="\033[31m"
readonly COL_GREEN="\033[32m"
readonly COL_YELLOW="\033[33m"
readonly COL_PURPLE="\033[34m"

# Show help.
show_help() {
  echo "Usage: install.sh [OPTION]
Install configured dotfiles to the root of a macOS system.

Options:
  -h, --help     Show this help message and exit.
  -f, --force    Used to force install without prompting for confirmation.
  -u, --update   Updates the script and the terminal/prompt themes."
}

# Initialise (or reinitialise) sudo to save unhelpful prompts later.
sudo_init() {
  if ! sudo -vn &> /dev/null; then
    if [[ "${BOOTSTRAP_SUDOED_ONCE}" -eq 1 ]]; then
      # Use "echo" here, instead of log_info. It's too early.
      echo -e "${COL_PURPLE}==>${COL_RESET}${COL_BOLD} Re-enter your password (for sudo access; sudo has timed out)${COL_RESET}"
    else
      # Use "echo" here, instead of log_info. It's too early.
      echo -e "${COL_PURPLE}==>${COL_RESET}${COL_BOLD} Enter your password (for sudo access)${COL_RESET}"
    fi
    sudo /usr/bin/true
    BOOTSTRAP_SUDOED_ONCE=1
  fi
}

# Colourful terminal log outputs.
log_info() {
  # Everytime we log an output also check if sudo is initialised. It is doubtful
  # that a password will need to be entered more than once as the script
  # shouldn't take long to run. But in the event it does at least it will be at
  # a more sensible time with a more sensible message.
  sudo_init

  printf "${COL_PURPLE}==>${COL_RESET}${COL_BOLD} %b${COL_RESET}\r\n" "$1"
}

log_success() {
  printf "${COL_GREEN}==>${COL_RESET}${COL_BOLD} %b${COL_RESET}\r\n" "$1"
}

log_warn() {
  printf "${COL_YELLOW}==>${COL_RESET}${COL_BOLD} %b${COL_RESET}\r\n" "$1"
}

log_error() {
  printf "${COL_RED}==>${COL_RESET}${COL_BOLD} Error: %b${COL_RESET}\r\n" "$1"
}

# Make sure user is not using sudo/running as root and that the user is in the
# admin group.
check_sudo() {
  if [[ "${USER}" = "root" ]]; then
    log_error "Run install.sh as yourself, not root"
    exit 1
  else
    if ! groups | grep --quiet -E "\b(admin)\b"; then
      log_error "Add ${USER} to the admin group"
      exit 1
    fi
  fi
}

# Installs the Terminal theme. This function is in this file (maybe not the most
# appropriate place) because it is used by both the run_update() function and
# the setup_one_dark_terminal() functions.
install_terminal_theme() {
  osascript <<EOD
tell application "Terminal"
  set custom title of every window to "alreadyOpenedTerminalWindows"
  do shell script "open '${TERMINAL_THEMES_DIR}/atom-one-dark-terminal/scheme/terminal/One Dark.terminal'"
  do shell script "sleep 10"
  do shell script "defaults write com.apple.Terminal 'Default Window Settings' -string 'One Dark'"
  do shell script "defaults write com.apple.Terminal 'Startup Window Settings' -string 'One Dark'"
  close (every window whose name does not contain "alreadyOpenedTerminalWindows")
end tell
EOD
}

run_update() {
  # Check we are running latest version.
  log_info "Updating to the latest version of the script..."
  git pull --quiet origin master
  log_success "Update complete!"

  # Check we have the latest version of the Spaceship Prompt Theme
  log_info "Updating to the latest version of the Spaceship Prompt theme..."
  pushd "${PROMPT_THEMES_DIR}/spaceship-prompt" > /dev/null || exit
  git pull --quiet origin master
  popd > /dev/null || exit
  log_success "Update complete!"

  # Check we have the latest version of the One Dark Terminal Theme
  log_info "Updating to the latest version of the One Dark Terminal theme..."
  pushd "${TERMINAL_THEMES_DIR}/atom-one-dark-terminal" > /dev/null || exit
  git pull --quiet origin master
  # Remove One Dark Theme from Terminal profiles.
  plutil -remove "Window Settings.One Dark" ~/Library/Preferences/com.apple.Terminal.plist
  # Re-add the latest version back to Terminal.
  install_terminal_theme
  popd > /dev/null || exit
  log_success "Update complete!"

  log_info "All updates complete! You will need to restart your Terminal before running an update again (plist madness). Would you like me to do this for you? [y/N]"
  read -r

  if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    killall Terminal &>/dev/null
  fi
}

main() {
  # Parse arguments.
  while [ $# -gt 0 ]; do
    case $1 in
      --help | -h)
      show_help
      return
      ;;
      --force | -f)
      # shellcheck disable=SC2034
      FORCE=1
      ;;
      --update | -u)
      run_update
      return
    esac
    shift
  done

  # Reset sudo timestamp so we always prompt for sudo password at least once
  # rather than doing root stuff unexpectedly.
  sudo --reset-timestamp

  check_sudo

  # Install Homebrew.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/brew.sh"

  # Install dotfiles.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/dotfiles.sh"

  # Install macOS defaults.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/macos.sh"

  # Final system configuration.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/after_install.sh"

  # Final success message and ask the user if they would like to restart the
  # system. Don't reboot on Travis CI.
  if [[ "${CI}" -ne 1 ]]; then
    if [[ ${FORCE} -ne 1 ]]; then
      log_info "Some changes may require a reboot to take effect. Would you like to reboot now? [y/N]"
      read -r
    fi

    if [[ ${REPLY} =~ ^([yY][eE][sS]|[yY])+$ ]] || [[ ${FORCE} -eq 1 ]]; then
      log_info "Your system will reboot in 5 seconds..."
      sleep 5
      sudo shutdown -r now
    else
      log_warn "Skipping system reboot! Although most things will function without issue, there could be certain undesired effects until the next time you reboot"
    fi
  fi
}

main "$@"
