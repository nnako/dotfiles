#
## set source code path settings
#

prjname="APP__realms_wiki"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"

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

# for realms-wiki
sudo apt-get -qq install python-pip
sudo apt-get -qq install python-dev
sudo apt-get -qq install libxml2-dev
sudo apt-get -qq install libxslt1-dev
sudo apt-get -qq install zlib1g-dev
sudo apt-get -qq install libffi-dev
sudo apt-get -qq install libyaml-dev
sudo apt-get -qq install libssl-dev
sudo apt-get -qq install libsasl2-dev
sudo apt-get -qq install libldap2-dev

# web server
sudo apt-get -qq install nginx




#
## get and install relevant python modules from source
# other modules are handled from within the project's setup.py

# pyzmail
pip install realms-wiki




#
## configure nginx server
#

#...




# deactivate virtual environment
deactivate

