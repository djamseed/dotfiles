#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$HOME"
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
echo 'Installing Xcode command line tools ...'
check="$(xcode-select --install 2>&1)"
str='xcode-select: note: install requested for command line developer tools'
while [[ $check == "$str" ]]; do
    check="$(xcode-select --install 2>&1)"
    sleep 1
done

# Check for Homebrew and install if we don't have it
if ! test "$(which brew)"; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/usr/local/bin/brew shellenv)"
fi

echo 'Installing dotfiles...'
git clone --recursive https://github.com/djamseed/dotfiles ~/.dotfiles && cd ~/.dotfiles

# Update Homebrew recipes
brew update

# Install all dependencies with brew bundle (See Brewfile)
brew bundle

# Change the shell to bash
if ! grep -q "$(which bash)" /etc/shells; then
    sudo sh -c 'echo "$(which bash)" >> /etc/shells'
fi

chsh -s "$(which bash)"

# Create symlinks from this repo to the $HOME directory
find . -type f -name ".*" ! -name ".editorconfig" ! -name ".gitattributes" ! -name ".gitignore" ! -name ".gitmodules" ! -name ".config" ! -name ".git" -exec sh -c '
    for file do
        f=$(basename "$file")
        ln -sfn "$PWD/$file" "$HOME/$f"
    done
' sh {} +

# Create symlinks from the bin directory to /usr/local/bin
for f in "$PW"D/bin/*; do
    if [ -f "$f" ]; then
        ln -sfn "$PWD/bin/$f" "/usr/local/bin/$f"
    fi
done

# Ignore changes in the .gitconfig file
git update-index --skip-worktree "$PWD"/.gitconfig

# Create the .config folder in $HOME
mkdir -p "$HOME"/.config

# Create symlinks from the .config folder to ~/.config
ln -sfn "$PWD"/.config/1Password "$HOME/.config/1Password"
ln -sfn "$PWD"/.config/alacritty "$HOME/.config/alacritty"
ln -sfn "$PWD"/.config/mpv "$HOME/.config/mpv"
ln -sfn "$PWD"/.config/nvim "$HOME/.config/nvim"
ln -sfn "$PWD"/.config/tmux "$HOME/.config/tmux"
ln -sfn "$PWD"/.config/starship.toml "$HOME/.config/starship.toml"

# Set macOS preferences (sane defaults)
source macos.sh

printf '\u2728\e[1;33m Installation completed! \u2728 \e[m\n'
read -r '?Press any key to reboot your computer...: '

# Restart to make the settings effective
sudo reboot
