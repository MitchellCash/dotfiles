# Mitchell's dotfiles

## Installation

### Using Git and the bootstrap script

```bash
git clone https://github.com/mitchellcash/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into the `dotfiles` repository and then:

```bash
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
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

### Install Homebrew formulae

When setting up a new Mac, install some common [Homebrew](http://brew.sh) formulae (after installing Homebrew, of course):

```bash
./brew.sh
```

Some of the functionality of these dotfiles depends on formulae installed by `brew.sh`.

## Thanks to…

* [Mathias Bynens](https://mathiasbynens.be) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
