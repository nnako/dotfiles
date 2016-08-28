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
## get and prepare project files
#

# get source code
git clone $prjpath $HOME/$prjname

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

# libffi-dev
sudo apt-get -qq install libffi-dev   # required for mailbot module




#
## get and install relevant python modules from source
# other modules are handled from within the project's setup.py

# pyzmail
pip install pyzmail

# argparse
#pip install argparse



#
## get mailbot plugin from source
#

# get source
git clone $libpath_mailbot $HOME/$libname_mailbot

# build mailbot into paython packages
cd $HOME/$libname_mailbot
python setup.py install




#
## get freeplane api
#

# get source
git clone $libpath_freeplane $HOME/$libname_freeplane

# get dependencies
pip install html2text

# build freeplane api into python packages
cd $HOME/$libname_freeplane
python setup.py install




#
## get relevant applications
#

# dropbox uploader
git clone $apppath_dropbox $HOME/$appname_dropbox




# deactivate virtual environment
deactivate

