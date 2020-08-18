#
# set source code path settings
#

prjname="APP__surveillance"
#prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"
prjpath="https://bitbucket.com/nnako/surveillance.git"

# move into Python v2 virtual environment if possible
#workon $sPython2venv




#
# get and prepare project folders
#

# get project source code (if not already present)
if [[ ! -d "$HOME/$prjname" ]]; then
    git clone $prjpath $HOME/$prjname
fi

# move into project folder
cd $HOME/$prjname

# prepare executable application (neccessity of click module)
#pip install --editable .

# create temporary project folder (if not existent)
if [[ ! -d "$HOME/.$prjname" ]]; then
    mkdir $HOME/.$prjname
fi




#
# get and install relevant packages (if not already present)
#

# used applications
#  -> picamera   Application and Python module for camera access
#  -> pillow     Python module for image manipulation
#  -> sendemail  CLI Application for transmission of emails

# define packages
packages=(
    python-picamera
    python3-picamera
    libjpeg-dev
    libjpeg62-dev
    zlib1g-dev
    libfreetype6-dev
    liblcms1-dev
    sendemail
    libio-socket-ssl-perl
    libnet-ssleay-perl
)

# filter packages which have already been installed
packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

# install using apt-get
if (( ${#packages[@]} > 0 )); then
  e_header "Installing APT packages\n${packages[*]}"
  for package in "${packages[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi





#
# install PIL
#

pip install pillow




#
# configure web service
#

#...




# deactivate virtual environment
#deactivate

