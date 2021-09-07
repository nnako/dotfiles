#
# set source code path settings
#

# project
prjname="APP__gateway"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"

# MAILBOT
libname_mailbot="LIB__mailbot"
libpath_mailbot="pi@192.168.1.49:/home/pi/usbdrv/_python/$libname_mailbot.git"

# FREEPLANE
libname_freeplane="LIB__freeplane"
libpath_freeplane="pi@192.168.1.49:/home/pi/usbdrv/_python/$libname_freeplane.git"

# DROPBOX
appname_dropbox="Dropbox-Uploader"
appname_dropbox_local="dropbox_updater"
apppath_dropbox="https://github.com/andreafabrizi/$appname_dropbox.git"

# DEV ENV
envname="ENV__gateway__py3"




#
# create and activate virtual environment
#

# get create python3 virtual environment (if not already present)
if [[ ! -d "$HOME/$envname" ]]; then
    python3 -m venv $HOME/$envname
fi

# activate
source /home/pi/$envname/bin/activate




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
pip install --editable .

# create temporary project folder (if not existent)
if [[ ! -d "$HOME/.$prjname" ]]; then
    mkdir $HOME/.$prjname
fi

cd ..




#
# get relevant packages (if not already present)
#

## email processing
#sudo apt -qq install libffi-dev             # required for mailbot module
#sudo apt -qq install sendemail              # required for email attachments
#sudo apt -qq install libio-socket-ssl-perl  # required for sendemail on RPi
#sudo apt -qq install libnet-ssleay-perl     # required for sendemail on RPi

## audio processing
#sudo apt -qq install alsa                   # required for sound output
#sudo apt -qq install mplayer                # required for sound replay
#sudo apt -qq install festival               # festival speech package and application
#sudo apt -qq install espeak                 # espeak speech package and application

## image processing
#sudo apt -qq install imagemagick            # for operations on bitmap graphics
#sudo apt -qq install pdftk                  # for operations on PDF files

# define packages
packages=(
  libffi-dev
  sendemail
  libio-socket-ssl-perl
  libnet-ssleay-perl
  imagemagick
  pdftk
)

# filter packages which have already been installed
packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

# install using apt
if (( ${#packages[@]} > 0 )); then
  e_header "Installing SYSTEM PACKAGES and APPLICATIONS\n${packages[*]}"
  for package in "${packages[@]}"; do
    sudo apt -y -qq install "$package"
  done
fi




#
# get and install relevant python modules from source
#

# other modules are handled from within the project's setup.py

pip install pyzmail
pip install pyocclient
pip install argparse
pip install configparser
pip install markdown
pip install pexpect
pip install html2text
pip install lxml




#
# get mailbot plugin from source
#

# get source (only if directory was not present)
if [[ ! -d "$HOME/$libname_mailbot" ]]; then
    git clone $libpath_mailbot $HOME/$libname_mailbot
fi

# install local mailbot package (editable)
cd $HOME/$libname_mailbot
#python setup.py install
pip install -e .
cd ..




#
# get freeplane api
#

# get source (only if directory was not present)
if [[ ! -d "$HOME/$libname_freeplane" ]]; then
    git clone $libpath_freeplane $HOME/$libname_freeplane
fi

# get dependencies
#pip install html2text

# build freeplane api into python packages
cd $HOME/$libname_freeplane
python setup.py install




#
# get relevant applications
#

# get Dropbox-Uploader source (only if directory was not present)
if [[ ! -d "$HOME/$appname_dropbox_local" ]]; then
    git clone $apppath_dropbox $HOME/$appname_dropbox_local
fi




# deactivate virtual environment
deactivate

