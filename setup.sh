#!/bin/bash

DOTFILES_DIR=~/dotfiles

# list of config files/directories to symlink
CONFIG_FILES=(awesome pulse kitty)

echo "Checking for updates..."
cd $DOTFILES_DIR

#pull the latest changes from the remote repo
git pull

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
echo "Dotfiles setup complete."