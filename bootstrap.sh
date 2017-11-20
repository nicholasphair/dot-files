#!/bin/bash
#
# =============================================================================
# Script to setup our environment.
# Author: Nick Phair
# Date: November 20, 2017
# Version: v.2.0.0
# =============================================================================

# TODO: Add logic for a cli.
# TODO: Call script to grab all packages we need.
# TODO: Figure out how to make CONFIGS multilined.
# TODO: Refactor. Perhaps move logic into functions. May not be needed.

BACKUP_DIR=$HOME/.rcs
HISTORY_DIR=$HOME/.history
CONFIGS="screenrc bashrc bash_profile inputrc gitignore gitconfig vim wgetrc"

contains() {
    if [[ $CONFIGS =~ (^| )$1($| ) ]]; then
        return 1;
    else
        return 0;
    fi
}

# Build our needed directories.
mkdir -p $BACKUP_DIR
mkdir -p $HISTORY_DIR

# Make backups.
for config in $CONFIGS; do
    dot_file="$HOME/.$config"
    if [ -e "$dot_file" ]; then
        #mv $dot_file $BACKUP_DIR
        echo "$dot_file has been backed up to the $BACKUP_DIR directory."
    fi
done

# Symlink our dot files.
for config in **/*; do
    dot_file="${config##*/}"
    contains $dot_file
    if [ $? = 1 ]; then
        echo "$config has been symlinked to $HOME/.$dot_file"
        #ln -s $config $HOME/.$dot_file
    else
        continue
    fi
done
