#
## user settings (static)
#

# python versions
vPython2=2.7.10          # version number for python v2
sPython2name=python2.7   # name of python v2 installation
sPython2venv=python27    # name of python v2 virtual environment
vPython3=3.4.2           # version number for python v3
sPython3name=python3.4   # name of python v3 installation
sPython3venv=python34    # name of python v3 virtual environment
sPythonBaseDir=/opt      # base folder name fo install python versions




#
# leave virtual environment if possible
#

#...




#
## install python version v2 from source
#

#if [[ ! -d $sPythonBaseDir/$sPython2name ]]; then

    e_header "... Python v${vPython2} from source into ${sPythonBaseDir}"

    # install python v2 from source
    cd /tmp
    wget https://www.python.org/ftp/python/${vPython2}/Python-${vPython2}.tgz
    tar -zxvf Python-${vPython2}.tgz
    cd Python-${vPython2}
    #./configure
    ./configure --prefix=${sPythonBaseDir}/${sPython2name}
    #make -j 4
    make
    sudo make install

#fi




#
## install python version v3 from source
#

if [[ ! -d $sPythonBaseDir/$sPython3name ]]; then

    e_header "... Python v${vPython3} from source into ${sPythonBaseDir}"

    # install python v3 from source
    cd /tmp
    wget https://www.python.org/ftp/python/${vPython3}/Python-${vPython3}.tgz
    tar xvzf Python-${vPython3}.tgz
    cd Python-${vPython3}/
    #./configure
    ./configure --prefix=${sPythonBaseDir}/${sPython3name}
    make
    sudo make install

    # link python3 and python3.4 to v3.4 (not v3.2)
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/bin/python3
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/local/bin/python3
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/bin/${sPython3name}
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/local/bin/${sPython3name}

fi




#
## install setuptools as well as pip
#

# set module name
sModuleName=python-setuptools

# install the module
if [[ ! "$(type -P ${sModuleName})" ]]; then
  e_header "Installing " ${sModuleName}
  sudo apt-get -qq install ${sModuleName} -y
  sudo easy_install pip
fi




#
# FIX problem with pip and lsb_release by renaming file
#

# somehow pip has a problem when lsb_release is installed
# so, removing or renaming the file should solve the problem
# it can be re-activated by re-renaming or by re-installing
# "using apt-get install lsb-core"

if [[ -d /usr/bin/lsb_release ]]; then
    sudo mv /usr/bin/lsb_release /usr/bin/x_lsb_release
fi




#
## install virtual environments
#

e_header "Installing Virtual Environments"

# install / update packages
sudo pip -qq install virtualenv
sudo pip -qq install virtualenvwrapper

# update configurations for current console
source ~/.profile

# ENV for python v2 and update pip
#if [[ ! -d $HOME/.virtualenvs/${sPython2venv} ]]; then
    mkvirtualenv ${sPython2venv} -p ${sPythonBaseDir}/${sPython2name}/bin/${sPython2name}
    sudo pip install -IU pip
    deactivate
#fi

# ENV for python v3 and update pip
if [[ ! -d $HOME/.virtualenvs/${sPython3venv} ]]; then
    mkvirtualenv ${sPython3venv} -p ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name}
    sudo pip install -IU pip
    deactivate
fi
