#!/bin/bash

set -eu
set -o pipefail

echo 'Preparing to install...'

# Ask for administrator password upfront
printf 'Password for your PC [\e[32m?\e[m] ' && sudo -v
# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
echo ''

# Check for Xcode command line tools and install if we don't have it
if ! xcode-select -p &>/dev/null; then
    echo 'Installing Xcode command line tools...'
    xcode-select --install
    echo 'Waiting for command line tools installation for Xcode to complete...'
    until xcode-select -p &>/dev/null; do
        sleep 1
    done
else
    echo 'Command Line Tools for Xcode are already installed.'
fi

# Check for Homebrew and install if we don't have it
if ! command -v brew &>/dev/null; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($(arch | grep -q arm64 && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew) shellenv)"
fi

echo 'Installing dotfiles...'
git clone --recursive https://github.com/djamseed/dotfiles "$HOME/.dotfiles" && cd "$HOME/.dotfiles"

# Default XDG paths
XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"

# Create required directories
echo "Creating required directory tree..."
mkdir -p "$XDG_CACHE_HOME"/{tldr,zsh}
mkdir -p "$XDG_CONFIG_HOME"/git/local
mkdir -p "$XDG_DATA_HOME"/{dotnet,go,tmux,zoxide}
mkdir -p "$XDG_STATE_HOME"/{less,zsh}
echo '...done'

# Update Homebrew recipes
brew update

# Install all dependencies with brew bundle (See Brewfile)
brew bundle

# Create symlinks from this repo to the $HOME directory
ln -sfn "$PWD/.zshenv" "$HOME/.zshenv"
ln -sfn "$PWD/.hushlogin" "$HOME/.hushlogin"

# Create symlinks from the .config folder to ~/.config
for file in "$PWD"/.config/*; do
    f=$(basename "$file")
    ln -sfn "$PWD/.config/$f" "$HOME/.config/$f"
done

# Set macOS preferences (sane defaults)
source macos.sh

printf '\u2728\e[1;33m Installation completed! \u2728 \e[m\n'
read -r -p '?Press any key to reboot your computer...: '

# Restart to make the settings effective
sudo reboot
