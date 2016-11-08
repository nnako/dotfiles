#
## set source code path settings
#

# project
prjname="APP__calmgt"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"

# freeplane
libname_freeplane="LIB__freeplane_api"
libpath_freeplane="pi@192.168.1.49:/home/pi/usbdrv/_python/$libname_freeplane.git"

# dropbox
appname_dropbox="Dropbox-Uploader"
apppath_dropbox="https://github.com/andreafabrizi/$appname_dropbox.git"

# owncloud
#...




#
## get and prepare project files
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




# move into Python v2 virtual environment
workon $sPython2venv




#
## get / update relevant packages
#

sudo apt-get -qq install remind   # for reminder application to be executable
sudo apt-get -qq install sendemail   # to be able to send emails from within CRON




#
## get and install relevant python modules from source
# other modules are handled from within the project's setup.py

# EXCEL read
pip install xlrd

# OWNCLOUD client
pip install pyocclient

# ...
#pip install argparse




#
## get freeplane api
#

# get source (only if directory was not present)
if [[ ! -d "$HOME/$libname_freeplane" ]]; then

    # clone project repository
    git clone $libpath_freeplane $HOME/$libname_freeplane

    # get needed modules
    pip install html2text

    # build module into python
    cd $HOME/$libname_freeplane
    python setup.py install

fi




#
## get relevant applications
#

# get Dropbox-Uploader source (only if directory was not present)
if [[ ! -d "$HOME/APP__dropbox_uploader" ]]; then
    git clone $apppath_dropbox $HOME/APP__dropbox_uploader
fi




# deactivate virtual environment
deactivate

