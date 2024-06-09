#!/bin/bash

DOTFILES_DIR=~/dotfiles

# list of config files/directories to symlink
CONFIG_FILES=(awesome pulse kitty xfce4)

echo "Checking for updates..."
cd $DOTFILES_DIR

# check if there are any differences between local and remote branches
git fetch origin
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse origin/main)

if [ $LOCAL != REMOTE ]; then
    echo "Checksum mismatch detected. Local checksum $LOCAL does not match remote checksum $REMOTE! Updating..."
    git pull origin main
else
    echo "Local repository is up to date"
fi

echo "Undoing any local uncommitted changes..."
git reset --hard HEAD

echo "Setting up dotfiles..."

# Iterate over each configuration file/directory
for file in "${CONFIG_FILES[@]}"; do
    # Remove existing config if it exists
    if [ -e ~/.config/$file ]; then
        echo "Removing existing $file configuration..."
        rm -rf ~/.config/$file
    fi
    
    # Create a symbolic link
    echo "Creating symlink for $file..."
    ln -s $DOTFILES_DIR/$file ~/.config/$file
    
    # Check if symlink was successfully created
    if [ -L ~/.config/$file ]; then
        echo "Symlink for $file created successfully."
    else
        echo "Failed to create symlink for $file."
    fi
done

echo "Checking for and correcting broken symlinks..."

broken_links_count=0

# Iterate over each file in ~/.config
for file in ~/.config/*; do
    # Check if it's a broken symlink pointing to DOTFILES_DIR
    if [ -L "$file" ] && [ ! -e "$file" ] && [ "$(readlink "$file")" == "$DOTFILES_DIR/$(basename "$file")" ]; then
        echo "Correcting broken symlink: $(basename "$file")"
        rm "$file"
        ln -s "$DOTFILES_DIR/$(basename "$file")" "$file"
        ((broken_links_count++))
    fi
done

# Check if broken symlinks were found
if [ "$broken_links_count" -eq 0 ]; then
    echo "$broken_links_count broken symlinks found."
	echo "#########################################################"
	echo "# Double check for broken symlinks if you have problems #"
	echo "#########################################################"
fi

echo "Dotfiles setup complete."
