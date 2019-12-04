#!/usr/bin/env bash
#
# macOS configurations and defaults.

log_info "== MACOS =="

setup_macos() {
  log_info "Configuring macOS..."

  # Close any open System Preferences panes, to prevent them from overriding
  # settings we’re about to change
  log_info "Quitting System Preferences app"
  osascript -e 'tell application "System Preferences" to quit'

  ###########################################################################
  # Preferences                                                             #
  ###########################################################################

  # General
  # ======

  log_info "Setting General preferences"

  # Always show scroll bars
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

  # Use LCD font smoothing when available
  defaults write NSGlobalDomain AppleFontSmoothing -int 1

  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Set sidebar icon size to medium
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

  # Disable automatic capitalization as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

  # Dock
  # ====

  log_info "Setting Dock preferences"

  # Set the icon size of Dock items to 36 pixels
  # defaults write com.apple.dock tilesize -int 36

  # Dock position on screen
  defaults write com.apple.dock orientation -string "bottom"

  # Minimise windows using scale effect
  defaults write com.apple.dock mineffect -string "scale"

  # Minimise windows into application icon
  defaults write com.apple.dock minimize-to-application -bool true

  # Don’t animate opening applications
  defaults write com.apple.dock launchanim -bool false

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

  # Remove the autohide Dock delay
  # defaults write com.apple.dock autohide-delay -float 0

  # Show indicators for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool true

  # Don't show recent apps in the Dock
  defaults write com.apple.dock show-recents -bool false

  # Remove the animation when hiding/showing the Dock
  # defaults write com.apple.dock autohide-time-modifier -float 0

  # Enable highlight hover effect for the grid view of a stack in the Dock
  defaults write com.apple.dock mouse-over-hilite-stack -bool true

  # Setup apps in the Dock
  defaults write com.apple.dock persistent-apps -array \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Launchpad.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/App Store.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/System Preferences.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Utilities/Terminal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-type</key><string>spacer-tile</string></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Tor Browser.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-type</key><string>spacer-tile</string></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/GIMP-2.10.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Reeder.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spark.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spotify.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Sourcetree.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
    '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

  # Finder
  # ======

  log_info "Setting Finder preferences"

  # Hide hard disks, external disks, connected servers, CDs, DVDs, and iPods on the desktop.
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop-bool false

  # New Finder windows show $HOME.
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

  # Open folders in windows instead of new tabs.
  defaults write com.apple.finder FinderSpawnTab -bool false

  # Hide Recent Tags from sidebar.
  defaults write com.apple.finder ShowRecentTags -bool false

  # Show all filename extensions.
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Keep folders on top when sorting by name.
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # When performing a search, search the current folder by default.
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Show hidden and system files.
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Use list view in all Finder windows by default.
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Finder: disable window animations and Get Info animations
  defaults write com.apple.finder DisableAllAnimations -bool true

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # Expand the following File Info panes:
  # “General”, “Open with”, and “Sharing & Permissions”
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

  # Keyboard
  # ========

  # Touch bar shows an expanded control strip.
  defaults write com.apple.touchbar.agent PresentationModeGlobal -string "fullControlStrip"

  # Press Fn key to show F1, F2, etc. keys on the touch bar
  defaults write com.apple.touchbar.agent PresentationModeFnModes -dict \
    fullControlStrip -string "functionKeys"

  # Mission Control
  # ===============

  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false

  # Group windows by application in Mission Control
  defaults write com.apple.dock expose-group-by-app -bool true

  # Siri
  # ====

  log_info "Setting Siri preferences"

  # Hide Siri in menu bar.
  defaults write com.apple.Siri StatusMenuVisible -bool false

  # Terminal
  # ========

  log_info "Setting Terminal preferences"

  # Enable Secure Keyboard Entry in Terminal.app.
  defaults write com.apple.Terminal SecureKeyboardEntry -bool true

  # Disable the line marks.
  defaults write com.apple.Terminal ShowLineMarks -bool false

  # TextEdit
  # ========

  log_info "Setting TextEdit preferences"

  # Use plain text mode for new TextEdit documents
  defaults write com.apple.TextEdit RichText -int 0

  # Open and save files as UTF-8 in TextEdit
  defaults write com.apple.TextEdit PlainTextEncoding -int 4
  defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

  ###########################################################################
  # Kill affected applications                                              #
  ###########################################################################

  # Kill a limited set of apps to put the defaults set above in place for
  # those apps. Obviously apps like the Terminal can't be killed yet as the
  # install.sh script will still be running and will instead require a restart
  # later on.
  for app in "cfprefsd" \
    "Dock" \
    "Finder" \
    "SystemUIServer"; do
    killall "${app}" &>/dev/null
  done

  log_success "macOS successfully configured!"
}

# Confirm with the user that proceeding to install may have undesired affects
if [[ ${FORCE} -ne 1 ]]; then
  log_info "Using this script to configure macOS can have undesired affects if you have not confirmed the defaults it is changing. Do you wish to proceed? [y/N]"
  read -r
fi

if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ || ${FORCE} -eq 1 ]]; then
  setup_macos
else
  log_warn "Skipping configuring macOS!"
fi
