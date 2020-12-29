#
# set source code path settings
#

# project
prjname="APP__calmgt"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"

# python
#...

# freeplane
#libname_freeplane="LIB__freeplane_api"
#libpath_freeplane="pi@192.168.1.49:/home/pi/usbdrv/_python/$libname_freeplane.git"

# dropbox  -  no dropbox needed, anymore
#appname_dropbox="Dropbox-Uploader"
#apppath_dropbox="https://github.com/andreafabrizi/$appname_dropbox.git"

# owncloud
#...




#
# get and prepare project files
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
#if [[ ! -d "$HOME/.$prjname" ]]; then
#    mkdir $HOME/.$prjname
#fi




#
# prepare Python environment
#

# create python environment
python3 -m venv ~/ENV__calmgt__py37

# move into Python v3 virtual environment
source ~/ENV__calmgt__py37/bin/activate




#
# get / update relevant packages
#

# define packages
packages=(
  remind
  sendemail
  libnet-ssleay-perl
  libio-socket-ssl-perl
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
# get and install relevant python modules with pip
#

# other modules are handled from within the project's setup.py

# EXCEL
pip install xlrd
pip install openpyxl

# POWERPOINT
pip install python-pptx

# FREEPLANE
pip install html2text
pip install lxml         # needs libxslt-dev [APT] to be installed on system

# GITLAB
pip install python-gitlab

# NEXTCLOUD
#pip install pyocclient

# INI FILE
#pip install configparser

# GUI
pip install easygui




#
# install and configure webdav
#

# this section holds the actions to be taken in order to install and configure
# the WebDav functionality on the local server. using WebDav, the local server
# can be synchronized with a remote NextCloud instance. As a preparation, a
# dedicated user should be set-up within the NextCloud instance and a specific
# folder should be shared with this user. thus, not the entire NextCloud
# instance gets synchronized but just a relevant part of it.

# unfortunately, the WebDav functionality is very slow. this results in long
# waiting times (~10s) for updating a single folder using "ls" or displaying
# the contents of a text file on the CLI using cat.

# it would be better to use the full-featured NextCloud client application
# within a windows-based execution environment. the proper NextCloud client
# uses SMB technology which is much faster than WebDav.

# instal webdav driver
sudo apt -y install davfs2

# permit access for user
sudo usermod -aG davfs2 pi

# create subfolders
mkdir ~/nextcloud
mkdir ~/.davfs2

# copy secrets template file
sudo cp /etc/davfs2/secrets ~/.davfs2/secrets

# adjust permissions
sudo chown pi:pi ~/.davfs2/secrets
sudo chmod 600 ~/.davfs2/secrets

# NOW EDIT SECRETS
# and put in this line
# https://<nextcloud-server-url>/remote.php/dav/files/<nc-user-name>/ <nc-user-name> <nc-user-password>
vim ~/.davfs2/secrets

# NOW EDIT FSTAB
# and put in this line
# https://<nextcloud-server-url>/remote.php/dav/files/<nc-user-name>/ /home/pi/nextcloud davfs user,rw,auto 0 0
sudo vim /etc/fstab

# mount WebDav file system. use "umount" do dismount the folder
sudo mount ~/nextcloud




#
# get freeplane api
#

# get source (only if directory was not present)
#if [[ ! -d "$HOME/$libname_freeplane" ]]; then

    # clone project repository
#    git clone $libpath_freeplane $HOME/$libname_freeplane

    # get needed modules
#    pip install html2text

    # build module into python
#    cd $HOME/$libname_freeplane
#    python setup.py install

#fi




#
# get relevant applications
#

# get Dropbox-Uploader source (only if directory was not present)
#if [[ ! -d "$HOME/APP__dropbox_uploader" ]]; then
#    git clone $apppath_dropbox $HOME/APP__dropbox_uploader
#fi




# deactivate virtual environment
deactivate

