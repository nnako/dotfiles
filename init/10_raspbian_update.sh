#
## check for execution permission
#

is_raspbian || return 1




#
## run device's configuration tool (e.g. to resize SD CARD)
#

e_header "PLEASE EXPAND SD CARD (if not already done)"
sudo raspi-config




#
## update and upgrade packages
#

e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade
