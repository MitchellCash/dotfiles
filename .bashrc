###########
# Exports #
###########

# ignoredups in Bash history causes lines matching the previous history entry to
# not be saved.
export HISTCONTROL="ignoredups"

#########
# Paths #
#########

remove_from_path() {
  [ -d "$1" ] || return
  # Doesn't work for first item in the PATH but I don't care.
  export PATH=${PATH//:$1/}
}

add_to_path() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

quiet_which() {
  which "$1" &>/dev/null
}

# Add paths to PATH in reverse order.
add_to_path "/sbin"
add_to_path "/usr/sbin"
add_to_path "/usr/local/sbin"
add_to_path "/bin"
add_to_path "/usr/bin"
add_to_path "/usr/local/bin"

# Add gpg (via GPG Suite) to PATH if it exists. We check if the gpg binary
# exists in the GPG Suite bin folder so that it doesn't get confused with
# another installation of gpg which could happen if we used which.
if [[ -f /usr/local/MacGPG2/bin/gpg ]]; then
    add_to_path "/usr/local/MacGPG2/bin"
fi

# Add pyenv to PATH if it exists. We check with the 'which' command rather than
# checking if the directory exists in case pyenv has been uninstalled and
# folders were not removed in the process. Travis check because Travis doing
# Travis things.
if [[ $TRAVIS_CI != "1" ]]; then
    quiet_which pyenv && add_to_path "$(pyenv root)/shims"
else
    quiet_which pyenv && export PATH="$(pyenv root)/shims:$PATH"
fi

# Add rbenv to PATH if it exists. We check with the 'which' command rather than
# checking if the directory exists in case pyenv has been uninstalled and
# folders were not removed in the process. Travis check because Travis doing
# Travis things.
if [[ $TRAVIS_CI != "1" ]]; then
    quiet_which pyenv && add_to_path "$(rbenv root)/shims"
else
    quiet_which pyenv && export PATH="$(rbenv root)/shims:$PATH"
fi

###########
# Aliases #
###########

# Use GNU ls with color output for `ls`.
alias ls="gls --color"

# Always enable colored `grep` output.
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#########
# Misc. #
#########

# Use a modified Solarized Dark 256 color theme for the color GNU ls utility
eval "$(gdircolors $HOME/.terminal-theme/.dircolors)"

# Load the shell dotfiles, and then some:
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
