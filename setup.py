#!/usr/bin/env python3

'''Quick and dirty script to setup our environment.
Author: Nick Phair
Date: July 15, 2017

Note: Uses Python 3.4+
'''

from argparse import ArgumentParser, FileType
from pathlib import Path
from shutil import move as mv
import logging as log

HOME = Path.home()
CWD = Path.cwd()
CONFIGS = [
    'bashrc', 'bash_aliases', 'bash_profile',
    'inputrc', 'gitignore', 'gitconfig',
    'screenrc', 'vim', 'wgetrc',
]

def symlink(includes):
    '''Put all the appropriate symlinks in place.'''

    for config in CWD.rglob('*'):
        if config.name in CONFIGS:
            dot_file = HOME/'.{}'.format(config.name)
            dot_file.symlink_to(config, config.is_dir())
            log.info(' {} has been symlinked to {}/'.format(
                str(config), str(dot_file)))

def backup(includes, backup_dir):
    '''Move the current configs to a backup directory.'''

    backup_dir.mkdir(exist_ok = True)
    for config in HOME.glob('.*'):
        if config.name[1:] in includes:
            mv(str(config), str(backup_dir/config.name))
            log.info(' {} has been backed up to the {} directory.'.format(
                str(config), backup_dir))

if __name__ == '__main__':
    parser = ArgumentParser(
        description = ('Configure your environment to use the config files '
                       'in the cloned dot-files directory.'))
    parser.add_argument(
        '-c', '--configs', nargs = '*', default = CONFIGS,
        type = str, metavar = 'configs', choices = CONFIGS,
        help = 'List of config files to symlink.')
    parser.add_argument(
        '-b', '--backup-dir', default = HOME/'.rcs',
        type = Path, metavar = 'backup_dir',
        help = "Directory to backup the rc files for the current user.")
    parser.add_argument(
        '--log', default = 'env_setup.log', 
        type = str, metavar = 'log',
        help = 'Log file for the changes to the directory.')
    args = parser.parse_args()

    log.basicConfig(filename = args.log, level = log.DEBUG)
    backup(args.configs, args.backup_dir)
    symlink(args.configs)
