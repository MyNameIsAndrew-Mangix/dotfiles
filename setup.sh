#!/bin/bash

DOTFILES_DIR=~/dotfiles

# list of config files/directories to symlink
CONFIG_FILES=(awesome pulse kitty)
	for file in "${CONFIG_FILES[@]}"; do
		# remove existing config if it exists
		rm -rf ~/.config/$file
		# create sym link
		ln -s $DOTFILES_DIR/$file ~/.config$file
	done
