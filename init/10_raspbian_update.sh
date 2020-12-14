#
# check for execution permission
#

is_raspbian || return 1




#
# run device's configuration tool (e.g. to resize SD CARD)
#

# THIS IS DONE AUTOMATICALLY WITH NEW IMAGES, SO IT IS NOT NEEDED, HERE

#e_header "PLEASE EXPAND SD CARD (if not already done)"
#sudo raspi-config




#
# update and upgrade packages
#

e_header "Upgrading LINUX DISTRIBUTION"
#sudo apt-get -qq update
sudo apt -qq update
#sudo apt-get -qq dist-upgrade
sudo apt -qq dist-upgrade
