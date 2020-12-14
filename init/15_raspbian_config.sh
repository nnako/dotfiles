#
# check for execution permission
#

is_raspbian || return 1




#
# install hardware relevant stuff
#

e_header "Configuring HARDWARE (keyboard, timezone,...)"

# keyboard, display and timezone
sudo dpkg-reconfigure locales
sudo dpkg-reconfigure keyboard-configuration
sudo dpkg-reconfigure tzdata
#sudo apt-get -qq install rpi-update
sudo apt -qq install rpi-update
sudo rpi-update
