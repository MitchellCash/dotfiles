# Mitchell's dotfiles

Status: [![Status](https://travis-ci.com/mitchellcash/dotfiles.svg?branch=master)](https://travis-ci.com/mitchellcash/dotfiles)

A script to bootstrap and configure a macOS system.

![dotfiles](https://user-images.githubusercontent.com/8009243/41946792-8be1acb2-79f7-11e8-97df-e027610cfd27.png)

## Features

* Installs Homebrew (for installing command-line software)
* Installs Homebrew Bundle (for bundler-like Brewfile support)
* Installs Homebrew Cask (for installing graphical software)
* Installs software from a user's Brewfile in their home directory
* Installs dotfiles into a user's home directory
* Has a user friendly output with warnings when the user is about to perform a destructive action

The scripts are tested and confirmed to work on both macOS `10.12` and `10.13`.

## Usage

To run locally:

```bash
git clone https://github.com/mitchellcash/dotfiles.git
cd dotfiles
./script/install.sh
```

For help run:

```bash
./script/install.sh --help
```

### Add custom commands

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
GIT_AUTHOR_NAME="Mitchell Cash"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="mitchell@mitchellcash.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### Sensible macOS defaults

When setting up a new Mac, set some sensible macOS defaults:

```bash
./script/macos.sh
```

## Thanks to…

So many other cool dotfiles which inspired my own! To name a few:

* Mathias Bynens inspiring me with his macOS defaults from his [dotfiles](https://github.com/mathiasbynens/dotfiles) repository
* Mike McQuaid inspiring me with his Homebrew configuration from his [dotfiles](https://github.com/MikeMcQuaid/dotfiles) and [strap](https://github.com/MikeMcQuaid/strap) repositories
* Adam Eivy inspiring me to have some fun and bring some colour to my terminal outputs from his [dotfiles](https://github.com/atomantic/dotfiles) repository
