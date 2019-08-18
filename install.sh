#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status (non-zero exit
# status denotes failure).
set -e

# Store relative path as a variable.
readonly DOTFILESDIRREL=$(dirname "$0")

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
  -h, --help      Show this help message and exit.
  -f, --force     Used to force install without prompting for confirmation."
  exit 0
}

# Initialise (or reinitialise) sudo to save unhelpful prompts later.
sudo_init() {
    if ! sudo -vn &>/dev/null; then
      if [ -n "$BOOTSTRAP_SUDOED_ONCE" ]; then
        echo -e "${COL_PURPLE}==>${COL_RESET}${COL_BOLD} Re-enter your password (for sudo access; sudo has timed out)${COL_RESET}"
      else
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
    exit 1
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
      FORCE=1
      ;;
    esac
    shift
  done

  # Reset sudo timestamp so we always prompt for sudo password at least once
  # rather than doing root stuff unexpectedly.
  sudo --reset-timestamp

  # Make sure not running as root user and that $USER is in the admin group.
  [ "$USER" = "root" ] && log_error "Run bootstrap.sh as yourself, not root"
  # shellcheck disable=SC2086
  groups | grep $Q admin &> /dev/null || log_error "Add $USER to the admin group"

  # Check we are running latest version.
  log_info "Checking we are using the latest version of the script"
  git pull origin master

  # Install Homebrew.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/brew.sh"

  # Install dotfiles.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/dotfiles.sh"

  # Install nvm (nvm advises not to be installed by Homebrew).
  # See: https://github.com/nvm-sh/nvm#installation-and-update
  # TODO: Put this in a better place?
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | PROFILE=~/.zshrc bash

  # Install macOS defaults.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/macos.sh"

  # Final system configuration.
  # shellcheck disable=SC1090
  source "$DOTFILESDIRREL/script/after_install.sh"
}

main "$@"
