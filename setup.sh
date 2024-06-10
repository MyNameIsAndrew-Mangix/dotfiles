#!/bin/bash

export COMMAND="$1"
# Function to display script usage
usage() {
    echo "Usage: $0 [-ns|--no-sync] [-s|--sync]" >&2
    echo "Options:" >&2
    echo "  -ns, --no-sync   Skip syncing changes and keep local uncommitted changes" >&2
    echo "  -s, --sync       Sync changes and undo local uncommitted changes" >&2
    exit 1
}
USER_HOME=$(realpath ~)
DOTFILES_DIR="$USER_HOME/dotfiles"
SYNC_CHANGES=TRUE


# list of config files/directories to symlink
CONFIG_FILES=(awesome pulse kitty xfce4)

sync_changes() {
    echo "Checking for updates..."
    cd "$DOTFILES_DIR"

    # check if there are any differences between local and remote branches
    git fetch origin
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse origin/main)

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Checksum mismatch detected. Local checksum $LOCAL does not match remote checksum $REMOTE! Updating..."
        git pull origin main
    else
        echo "Local repository is up to date"
    fi

    echo "Undoing any local uncommitted changes..."
    git reset --hard HEAD
}

echo "Setting up dotfiles..."

configure_files() {
    # Iterate over each configuration file/directory
    for file in "${CONFIG_FILES[@]}"; do
        # Remove existing config if it exists
        if [ -e $USER_HOME/.config/$file ]; then
            echo "Removing existing $file configuration..."
            rm -rf $USER_HOME/.config/$file
        fi

        if [ $file == "pulse" ]; then
            echo "Creating symlink for $file..."
            ln -s $DOTFILES_DIR/$file $USER_HOME/.pulse 

            if [ -L $USER_HOME/.config/pulse ]; then
                echo "Symlink for pulse created successfully."
            else
                echo "Failed to create symlink for pulse."
            fi
            continue
        fi
        
        # Create a symbolic link if it doesn't already exist
        if [ ! -L "$USER_HOME/.config/$file" ]; then
            echo "Creating symlink for $file..."
            ln -s "$DOTFILES_DIR/$file" "$USER_HOME/.config/$file"
            if [ -L "$USER_HOME/.config/$file" ]; then
                echo "Symlink for $file created successfully."
            else
                echo "Failed to create symlink for $file."
            fi
        else
            echo "Symlink for $file already exists. Skipping..."
        fi
    done

    echo "Checking for and correcting broken symlinks..."

    broken_links_count=0

    # Iterate over each file in $USER_HOME/.config
    for file in $USER_HOME/.config/*; do
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
}

# Parse command line arguments
COMMAND="$1"
case $COMMAND in
    -ns|--no-sync)
    SYNC_CHANGES=false
    shift
    ;;
    -s|--sync)
    SYNC_CHANGES=true
    shift
    ;;
    *)
    echo "Unknown option: $1"
    usage
    ;;
esac

if [ "$SYNC_CHANGES" = true ]; then
    sync_changes
    configure_files
else
    configure_files
fi



