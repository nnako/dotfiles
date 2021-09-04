#
# set source code path settings
#

# project
prjname="APP__gitpi"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"




#
# get and prepare project files
#

# get project source code (if not already present)
if [[ ! -d "$HOME/$prjname" ]]; then
    git clone $prjpath $HOME/$prjname
fi

# create temporary project folder (if not existent)
if [[ ! -d "$HOME/.$prjname" ]]; then
    mkdir $HOME/.$prjname
fi




#
# get / update relevant packages
#

# define packages
packages=(
  wget
  git
)

# filter packages which have already been installed
packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

# install using apt
if (( ${#packages[@]} > 0 )); then
  e_header "Installing SYSTEM PACKAGES and APPLICATIONS\n${packages[*]}"
  for package in "${packages[@]}"; do
    #sudo apt-get -qq install "$package"
    sudo apt -y install "$package"
  done
fi




#
# create file system structure
#

# create mount point
if [[ ! -d "$HOME/usbdrv" ]]; then




    #
    # create mount point
    #

    mkdir $HOME/usbdrv




    #
    # read block device id
    #

    # read out block device identification in order to be able to insert
    # appropriate information into the filesystem table. e.g. use "sudo blkid"
    # on the command line to see a list of available devices and check the
    # desired one.




    #
    # edit file system table
    #

    # now you know the identification of the desired device to be mounted.
    # please, open the file system table using "sudo vi /etc/fstab" on the
    # command line. now, you can add the following line as the last line within
    # the file:
    #
    # /dev/sda1 /home/pi/usbdrv vfat uid=pi,gid=pi,umask=0022,sync,auto,nosuid,rw,nouser 0 0

fi




#
# create entries in crontab
#




