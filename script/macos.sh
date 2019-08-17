#!/usr/bin/env bash
#
# macOS configurations and defaults.

log_info "Preparing to setup macOS"

function setup_macos() {

	# Close any open System Preferences panes, to prevent them from overriding
	# settings we’re about to change
	log_info "Quitting System Preferences app"
	osascript -e 'tell application "System Preferences" to quit'

	###########################################################################
	# Preferences                                                             #
	###########################################################################

	# Global
	# ======

	log_info "Setting Global preferences"

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

	# Show all filename extensions.
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	# Set sidebar icon size to medium
	defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

	# Disable the over-the-top focus ring animation
	defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

	# Disable automatic capitalization as it’s annoying when typing code
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

	# Enable spring loading for directories
	defaults write NSGlobalDomain com.apple.springing.enabled -bool true

	# Remove the spring loading delay for directories
	defaults write NSGlobalDomain com.apple.springing.delay -float 0

	# Dashboard
	# =========

	log_info "Setting Dashboard preferences"

	# Disable Dashboard
	defaults write com.apple.dashboard mcx-disabled -bool true

	# Dock
	# ====

	log_info "Setting Dock preferences"

	# Minimise windows using scale effect
	defaults write com.apple.dock mineffect -string "scale"

	# Minimise windows into application icon
	defaults write com.apple.dock minimize-to-application -bool true

	# Don’t animate opening applications
	defaults write com.apple.dock launchanim -bool false

	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true

	# Remove the autohide Dock delay
	defaults write com.apple.dock autohide-delay -float 0

	# Remove the animation when hiding/showing the Dock
	defaults write com.apple.dock autohide-time-modifier -float 0

	# Enable highlight hover effect for the grid view of a stack in the Dock
	defaults write com.apple.dock mouse-over-hilite-stack -bool true

	# Set the icon size of Dock items to 36 pixels
	defaults write com.apple.dock tilesize -int 36

	# Enable spring loading for all Dock items
	defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Speed up Mission Control animations
	defaults write com.apple.dock expose-animation-duration -float 0.1

	# Don’t group windows by application in Mission Control
	# (i.e. use the old Exposé behavior instead)
	defaults write com.apple.dock expose-group-by-app -bool false

	# Don’t show Dashboard as a Space
	defaults write com.apple.dock dashboard-in-overlay -bool true

	# Don’t automatically rearrange Spaces based on most recent use
	defaults write com.apple.dock mru-spaces -bool false

	# Don't show recent apps in the Dock
	defaults write com.apple.dock show-recents -bool false

	# Setup apps in the Dock
	defaults write com.apple.dock persistent-apps -array \
		'<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Launchpad.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
		'<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/App Store.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
		'<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/System Preferences.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
		'<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Utilities/Terminal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
		'<dict><key>tile-type</key><string>spacer-tile</string></dict>' \
		'<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
		'<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
		'<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/TorBrowser.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' \
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

	# Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	# Expand the following File Info panes:
	# “General”, “Open with”, and “Sharing & Permissions”
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
		General -bool true \
		OpenWith -bool true \
		Privileges -bool true

    # iTunes
	# ======

	log_info "Setting iTunes preferences"

	# Don't open iTunes when a device is plugged in
	defaults write com.apple.iTunes dontAutomaticallySyncIPods -bool true

	# Screen Capture
	# ==============

	log_info "Setting Screen Capture preferences"

	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true

	# Screensaver
	# ===========

	log_info "Setting Screensaver preferences"

	# Require password immediately after sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

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

	# Only use UTF-8 in Terminal.app
	defaults write com.apple.terminal StringEncodings -array 4

	# Use a modified version of the Solarized Dark theme by default in Terminal.app
osascript <<EOD

tell application "Terminal"
	set custom title of every window to "alreadyOpenedTerminalWindows"
	do shell script "open '$HOME/.terminal-theme/Solarized Dark xterm-256color.terminal'"
    do shell script "sleep 10"
	do shell script "defaults write com.apple.Terminal 'Default Window Settings' -string 'Solarized Dark xterm-256color'"
	do shell script "defaults write com.apple.Terminal 'Startup Window Settings' -string 'Solarized Dark xterm-256color'"
	close (every window whose name does not contain "alreadyOpenedTerminalWindows")
end tell

EOD

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

}

# Confirm with the user that proceeding to install may have undesired affects
if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
	log_info "Configuring macOS"
	setup_macos
	log_success "macOS successfully configured!"
else
	log_info "Using this script to configure macOS can have undesired affects if you have not confirmed the defaults it is chaning. Do you wish to proceed? [y/N]"
	read -r

	if [[ $REPLY =~ ^([yY][eE][sS]|[yY])+$ ]]; then
		log_info "Proceeding with configuring macOS"
		setup_macos
		log_success "macOS successfully configured!"
	else
		log_warn "Skipping configuring macOS"
	fi
fi
