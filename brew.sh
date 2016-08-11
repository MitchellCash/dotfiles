#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Check to see if Homebrew is installed and if not install it.
if brew --version | grep -Eoq "Homebrew (\d+\.)+\d+" ; then
  echo "Homebrew is already installed."
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some macOS tools.
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

# Install other useful binaries.
brew install git

# Install Homebrew Cask to extend Homebrew to macOS GUI applications.
brew install caskroom/cask/brew-cask

# Install useful macOS GUI applications.
brew cask install 1password
brew cask install atom
brew cask install backblaze
brew cask install dropbox
brew cask install firefox
brew cask install github-desktop
brew cask install google-chrome
brew cask install qbittorrent
brew cask install slack
brew cask install spotify
brew cask install tunnelblick
brew cask install vlc

# Remove outdated versions from the cellar.
brew cleanup
