#
## source code path settings
#

prjpath="pi@192.168.1.49:/home/pi/usbdrv/PRJ__PASTOR2GO.git"
libpath_mailbot="pi@192.168.1.49:/home/pi/usbdrv/_python/LIB__mailbot.git"
libpath_freeplane="pi@192.168.1.49:/home/pi/usbdrv/_python/LIB__freeplane_api.git"
apppath_dropbox="pi@192.168.1.49:/home/pi/usbdrv/_bash/APP__dropbox_uploader.git"

# move into Python v2 virtual environment
workon $sPython2venv




#
## get and prepare project files
#

# get source code
git clone $prjpath $HOME/PRJ__PASTOR2GO

# move into project folder
cd $HOME/PRJ__PASTOR2GO

# prepare executable application (neccessity of click module)
pip install --editable .




#
## get relevant packages
#

# libffi-dev
sudo apt-get install libffi-dev   # required for mailbot module




#
## get and install relevant python modules from source
# other modules are handled from within the project's setup.py

# click
#...

# mailbot
#...

# freeplane api
#...

# pyzmail
#...




#
## get relevant applications
#

# dropbox uploader
#...
