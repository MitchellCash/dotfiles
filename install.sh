#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status (non-zero exit
# status denotes failure).
set -e

# Show help
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage: install.sh [OPTION]
Install configured dotfiles to the root of a macOS system.

Options:
  -h, --help      Show this help message and exit.
  -f, --force     Used to force install without prompting for confirmation."
    exit 0
fi

# Reset sudo timestamp so we always prompt for sudo password at least once
# rather than doing root stuff unexpectedly.
sudo -k

# Store relative path as a variable.
DOTFILESDIRREL=$(dirname "$0")

# Colors for terminal log outputs.
ESC_SEQ="\\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RESET_BOLD=$ESC_SEQ"39;49;01m"
COL_GREEN=$ESC_SEQ"32m"
COL_PURPLE=$ESC_SEQ"34m"
COL_RED=$ESC_SEQ"31m"

# Initialise (or reinitialise) sudo to save unhelpful prompts later.
sudo_init() {
    if ! sudo -vn &>/dev/null; then
      if [ -n "$BOOTSTRAP_SUDOED_ONCE" ]; then
        echo -e "$COL_PURPLE==>$COL_RESET_BOLD Re-enter your password (for sudo access; sudo has timed out)$COL_RESET"
      else
        echo -e "$COL_PURPLE==>$COL_RESET_BOLD Enter your password (for sudo access)$COL_RESET"
      fi
      sudo /usr/bin/true
      BOOTSTRAP_SUDOED_ONCE="1"
    fi
}

# Colourful terminal log outputs.
function log() {
    # Everytime we log an output also check if sudo is initialised. It is doubtful
    # that a password will need to be entered more than once as the script
    # shouldn't take long to run. But in the event it does at least it will be at
    # a more sensible time with a more sensible message.
    sudo_init
    echo -e "$COL_PURPLE==>$COL_RESET_BOLD" "$1" "$COL_RESET"
}

function abort() {
    echo -e "$COL_RED==>$COL_RESET_BOLD Error!" "$1" "$COL_RESET"
    exit 1
}

function error() {
    echo -e "$COL_RED==>$COL_RESET_BOLD" "$1" "$COL_RESET"
}

function success() {
    echo -e "$COL_GREEN==>$COL_RESET_BOLD" "$1" "$COL_RESET"
}

# Make sure not running as root user and that $USER is in the admin group.
[ "$USER" = "root" ] && abort "Run bootstrap.sh as yourself, not root"
# shellcheck disable=SC2086
groups | grep $Q admin &> /dev/null || abort "Add $USER to the admin group"

# Check we are running latest version.
log "Checking we are using the latest version of the script"
git pull origin master

# Install Homebrew.
# shellcheck disable=SC1090
source "$DOTFILESDIRREL/script/brew.sh"

# Install dotfiles.
# shellcheck disable=SC1090
source "$DOTFILESDIRREL/script/dotfiles.sh"

# Install macOS defaults.
# shellcheck disable=SC1090
source "$DOTFILESDIRREL/script/macos.sh"

# Function to reboot the computer after waiting 5 seconds.
function reboot() {
    sleep 5
    sudo shutdown -r now
}

# Final success message and ask the user if they would like to restart the
# system. Don't reboot on Travis CI.
if [[ $TRAVIS_CI != "1" ]]; then
    if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
        success "Your system has been successfully setup! Note some changes will require a reboot to take effect. Your system will reboot in 5 seconds."
        reboot
    else
        success "Your system has been successfully setup! Note some changes will require a reboot to take effect. Would you like to reboot now? [y/N]"
        read -r

        if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            log "Your system will reboot in 5 seconds."
            reboot
        else
            error "Skipping system reboot. Note that although most things will function without issue, there could be certain undesired effects until the next time you reboot."
        fi
    fi
fi
