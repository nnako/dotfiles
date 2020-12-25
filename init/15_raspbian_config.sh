#
# check for execution permission
#

is_raspbian || return 1




#
# install hardware relevant stuff
#

e_header "Configuring LANGUAGE, KEYBOARD and TIMEZONE"

# system display language configuration
sudo dpkg-reconfigure locales

# keyboard configuration
sudo dpkg-reconfigure keyboard-configuration

# timezone configuration
sudo dpkg-reconfigure tzdata

# prompt for RPI-UPDATE
#sudo apt -y install rpi-update
#sudo rpi-update
