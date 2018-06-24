#!/usr/bin/env bash

DOTFILESDIRREL=$(dirname $0)
cd $DOTFILESDIRREL/.. || exit

git pull origin master;

function bootstrap() {
    rsync --exclude ".git/" \
        --exclude "script/" \
        --exclude ".DS_Store" \
        --exclude ".macos" \
        --exclude "brew.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;
    source ~/.bash_profile;
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    bootstrap;
else
    echo -e "\n"
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo -e "\n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bootstrap;
    fi;
fi;

unset bootstrap;
