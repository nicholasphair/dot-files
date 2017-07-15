## Dot Files.
This is the current state of all of my dot files.

### setup.py
##### Requires Python 3.6
Provided is setup.py, a script to set up the user's environment to use the 
cloned dot files. Simply run the script and it will generate all the required
symlinks. Any existing dot-files will be copied to the ~/.rcs/ directory.
```shell
python3.6 setup.py

# Or with +x permissions...
./setup.py
```

Note that after you run the script you should relaunch your terminal or source
the appropriate files for the changes to take effect.
