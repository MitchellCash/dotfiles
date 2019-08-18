# Mitchell's dotfiles

Status: [![Status](https://travis-ci.com/MitchellCash/dotfiles.svg?branch=master)](https://travis-ci.com/MitchellCash/dotfiles)

A script to bootstrap and configure a macOS system.

![dotfiles](https://user-images.githubusercontent.com/8009243/41946792-8be1acb2-79f7-11e8-97df-e027610cfd27.png)

## Features

* Installs Homebrew (for installing command-line software)
* Installs Homebrew Bundle (for bundler-like Brewfile support)
* Installs Homebrew Cask (for installing graphical software)
* Installs software from a user's Brewfile in their home directory
* Installs dotfiles into a user's home directory
* Has a user friendly output with warnings when the user is about to perform a destructive action

The scripts are tested on macOS `10.13` and `10.14`.

## Usage

Customise the `user.name` and `user.email` in [`gitconfig`](https://github.com/MitchellCash/dotfiles/blob/master/.dotfiles/gitconfig).

Run [`install.sh`](https://github.com/MitchellCash/dotfiles/blob/master/install.sh).

For help you can run `install.sh --help`.

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
