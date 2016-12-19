#
## set source code path settings
#

prjname="APP__gateway"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"
libname_mailbot="LIB__mailbot"
libpath_mailbot="pi@192.168.1.49:/home/pi/usbdrv/_python/$libname_mailbot.git"
libname_freeplane="LIB__freeplane_api"
libpath_freeplane="pi@192.168.1.49:/home/pi/usbdrv/_python/$libname_freeplane.git"
appname_dropbox="Dropbox-Uploader"
apppath_dropbox="https://github.com/andreafabrizi/$appname_dropbox.git"

# move into Python v2 virtual environment
workon $sPython2venv




#
## get and prepare project folders
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
## get relevant packages (if not already present)
#

# email processing
sudo apt-get -qq install libffi-dev   # required for mailbot module
sudo apt-get -qq install sendemail    # required for email attachments
sudo apt-get -qq install libio-socket-ssl-perl  # required for sendemail on RPi
sudo apt-get -qq install libnet-ssleay-perl     # required for sendemail on RPi

# audio processing
sudo apt-get -qq install alsa         # required for sound output
sudo apt-get -qq install mplayer      # required for sound replay
sudo apt-get -qq install festival     # festival speech package and application
sudo apt-get -qq install espeak       # espeak speech package and application

# image processing
sudo apt-get -qq install imagemagick  # for operations on bitmap graphics




#
## get and install relevant python modules from source
# other modules are handled from within the project's setup.py

pip install pyzmail
pip install pyocclient
pip install argparse



#
## get mailbot plugin from source
#

# get source (only if directory was not present)
if [[ ! -d "$HOME/$libname_mailbot" ]]; then
    git clone $libpath_mailbot $HOME/$libname_mailbot
fi

# build mailbot into python packages
cd $HOME/$libname_mailbot
python setup.py install




#
## get freeplane api
#

# get source (only if directory was not present)
if [[ ! -d "$HOME/$libname_freeplane" ]]; then
    git clone $libpath_freeplane $HOME/$libname_freeplane
fi

# get dependencies
pip install html2text

# build freeplane api into python packages
cd $HOME/$libname_freeplane
python setup.py install




#
## get relevant applications
#

# get Dropbox-Uploader source (only if directory was not present)
if [[ ! -d "$HOME/APP__dropbox_uploader" ]]; then
    git clone $apppath_dropbox $HOME/APP__dropbox_uploader
fi




# deactivate virtual environment
deactivate

