#!/usr/bin/env python3.6

'''Quick and dirty script to setup our environment.
Author: Nick Phair
Date: July 15, 2017

Note: Uses Python 3.6 - Get with the times!
'''

from pathlib import Path
from subprocess import run
from sys import stderr, exit
from functools import partial
perror = partial(print, file=stderr)

home = Path.home()
git_dir = Path.cwd()
backup_dir = home/'.rcs'
configs = {
    'bash-conf' : ['bashrc', 'bash_aliases', 'bash_profile',],
    'input-conf' : ['inputrc',],
    'screen-conf' : ['screenrc',],
    'vim-conf' : ['vim',],
    'wget-conf' : ['wgetrc',],
}

# Ensure we have a directory to back up the users current dot files.
try:
    backup_dir.mkdir()
except FileExistsError:
   perror('Backup directory already exists. Please remove it or sepcify another.')
   exit(1)

# Move existing files to the backup directory the symlink the new rc files.
print('Preparing home directory...')
for conf_dir, conf in configs.items():
    for c in conf:
        rc = home/'.{}'.format(c)
        if rc.exists():
            run(['mv', str(rc), str(backup_dir)])
            print('- Old {} has been moved to {}/'.format(str(rc), str(backup_dir)))
        link = git_dir/conf_dir/c
        rc.symlink_to(link, c == 'vim')
        rc.resolve()
        print('+ {} has been symlinked to {}/'.format(str(rc), str(link)))
