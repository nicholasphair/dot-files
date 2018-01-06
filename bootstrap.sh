#!/bin/bash

# =============================================================================
# Script to setup our environment.
# Author: Nick Phair
# Date: November 20, 2017
# Version: v.2.0.0
# =============================================================================

# TODO: Add logic for a cli.
# TODO: Call script to grab all packages we need.
# TODO: Figure out how to make CONFIGS multilined.
# TODO: Call pluginstall
# TODO: Refactor. Perhaps move logic into functions. May not be needed.

BACKUP_DIR=$HOME/.rcs
HISTORY_DIR=$HOME/.history
CONFIGS="screenrc bashrc bash_profile inputrc gitignore gitconfig vim wgetrc"

readonly PROGNAME=$(basename $0)
#readonly PROGDIR=$(readlink -m $(dirname $0))
readonly -a ARGS=("$@")

contains() {
    if [[ $CONFIGS =~ (^| )$1($| ) ]]; then
        return 1
    else
        return 0
    fi
}

# Build our needed directories.
build_dirs() {
    mkdir -p $HISTORY_DIR
}

# =====================================
# Backup current dotfiles.
# Arguments:
#   $1 -  The backup directory.
#   $2 -  Config file to backup (if exists).
# Returns:
#   None
# =====================================
backup() {
    local backup_dir=$1
    local configs=$2

    mkdir -p $backup_dir
    for config in $configs; do
        dot_file="$HOME/.$config"
        if [ -e "$dot_file" ]; then
            #mv $dot_file $BACKUP_DIR
            echo "$dot_file has been backed up to the $backup_dir directory."
        fi
    done
}

# Symlink our dot files.
symlink() {
    for config in **/*; do
        dot_file="${config##*/}"
        contains $dot_file
        if [ $? = 1 ]; then
            echo "$config has been symlinked to $HOME/.$dot_file"
            #ln -s $config $HOME/.$dot_file
        fi
    done
}

# =====================================
# Parse the user arguments.
# Arguments:
#   $1 - The user arguments.
# Returns:
#   None
# =====================================
parse_args() {
    local a=("$1")
    for x in "${a[@]}"; do
        echo "$x"
    done

    exit
    POSITIONAL=()
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -b|--backupdir)
                BACKUP_DIR="$2"
                shift # past argument
                shift # past value
                ;;
            -h|--help)
                EXTENSION="$2"
                shift # past argument
                shift # past value
                ;;
            -l|--log)
                LOGPATH="$2"
                shift # past argument
                shift # past value
                ;;
            *)    # unknown option
                POSITIONAL+=("$1") # save it in an array for later
                shift # past argument
                ;;
        esac
    done

    set -- "${POSITIONAL[@]}" # restore positional parameters
    echo $DEFAULT
}

main() {

    parse_args "${ARGS[@]}"
    exit
}
main
