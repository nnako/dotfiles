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
# get and install signal messenger application
#

# for sending signal messages. unfortunately, not all versions seem to run on a
# Raspberry Pi computer. so, currently the version 0.8.1 with reduced
# functionality (e.g. no deletion of messages possible)

# general update of packages in the system
sudo apt update
sudo apt upgrade

# this is a Java application
sudo apt install default-jdk

# required for authentication to display QR codes
sudo apt install qrencode

# get the command line application
wget http://www.elzershark.com/iobroker/rpi_signal-cli-0.8.1.tar
#wget https://github.com/AsamK/signal-cli/releases/download/v0.8.3/signal-cli-0.8.3.tar.gz
 
# unpack the command line application
sudo tar xf rpi_signal-cli-0.8.1.tar -C /opt
#sudo tar xf signal-cli-0.8.3.tar.gz -C /opt
 
# add link to executable
sudo ln -sf /opt/signal-cli-0.8.1/bin/signal-cli /usr/local/bin/
#sudo ln -sf /opt/signal-cli-0.8.3/bin/signal-cli /usr/local/bin/




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
pip install pudb         # TUI debugger

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
pip install jira

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




