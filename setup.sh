#!/bin/bash

DOTFILES_DIR=~/dotfiles

# list of config files/directories to symlink
CONFIG_FILES=(awesome pulse kitty)
	for file in "${CONFIG_FILES[@]}"; do
		# remove existing config if it exists
		if [ -e ~.config/$file ]; then
			echo "Removing existing $file configuration..."
			rm -rf ~/.config/$file
		fi
		# create sym link
		echo "Creating symlink for $file..."
		ln -s $DOTFILES_DIR/$file ~/.config$file
	done
	echo "Dotfiles setup complete."
