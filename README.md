# dotfiles

Inspired by cowboy's great [dotfiles repository](https://github.com/cowboy/dotfiles) which contains treasures of configuration files and executable scripts, I adapted an own version slightly modified in order to make it usable for working on **Raspberry Pi**. Please look up the details about concept and sequence of operation on cowboy's site.

## how to use this for configuration

After writing your favorite (most likely the latest) Raspbian operating system image on your SD card, inerting this SD card into your Raspberry Pi and powering it on, the Raspberry Pi will boot up. You can follow the booting process on a connected monitor, if you like. Now, open a bash console (from the windowing system or via SSH over the network) and put in your USER NAME like this:

`export github_user=YOUR_GITHUB_USER_NAME`

After that, type in this command line:

`bash -c "$(curl -fsSL https://raw.github.com/$github_user/dotfiles/master/bin/dotfiles.sh)" && source ~/.bashrc`

When you cloned this repository as "dotfiles" as your own repository, every *common* installations will run fine and create my favorite development environment on your computer. It consists of the following components:

* expand SD card to provide full capacity (requires a reboot)

after the restart, please just re-enter the command lines you see above. Then...

* hardware configuration (choice of language,...)
* update of common packages and RPi packages
* installation of python2 and python3 versions under `/opt/python...`
* installation of respective virtual environments under `~/.virtualenvs/python...`
* installation of the vim editor and several useful plugins

You can easily unserstand the sources and modify them as you wish.

Unfortunately, the *project* installations might not work for you, as you will not have the appropriate access rights to get the project sources. Please, make sure that you remove the project installation scripts from the `init` folder or deactivate the project installations from the user menu when the installation sequence starts (after the first reboot and restart).

