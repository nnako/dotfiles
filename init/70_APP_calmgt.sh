#
# set source code path settings
#

# project
prjname="APP__calmgt"
envname="ENV__calmgt__py3"
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
# prepare Python environment
#

# create python environment
python3 -m venv $HOME/$envname

# move into Python v3 virtual environment
source $HOME/$envname/bin/activate




#
# get and install relevant python modules with pip
#

# other modules are handled from within the project's setup.py

# GENERAL
pip install isoweek
pip install pyinstaller  # in order to be able to easily build one-file

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

# GUI
pip install easygui




#
# build applications locally
#

cd $HOME/$prjname

pyinstaller calmgt.py --onefile
pyinstaller calsync.py --onefile

cd $HOME




# deactivate virtual environment
deactivate




#
# create configuration files
#




#
# create entries in crontab
#




