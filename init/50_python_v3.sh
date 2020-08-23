#
## user settings (static)
#

# python versions
vPython3=3.8.5           # version number for python v3
sPython3name=python3.8   # name of python v3 installation
sPython3venv=python38    # name of python v3 virtual environment
sPythonBaseDir=/opt      # base folder name fo install python versions




#
# leave virtual environment if possible
#

deactivate




#
# install necessary packages
#

# define packages
packages=(
    libffi-dev
    libbz2-dev
    liblzma-dev
    libsqlite3-dev
    libncurses5-dev
    libgdbm-dev
    zlib1g-dev
    libreadline-dev
    libssl-dev
    tk-dev
    build-essential
    libncursesw5-dev
    libc6-dev
    openssl
    git
)

# filter packages which have already been installed
packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

# install using apt-get
if (( ${#packages[@]} > 0 )); then
  e_header "Installing APT packages\n${packages[*]}"
  for package in "${packages[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi




#
# install python version v3 from source
#

if [[ ! -d $sPythonBaseDir/$sPython3name ]]; then

    e_header "... Python v${vPython3} from source into ${sPythonBaseDir}"

    # install python v3 from source
    cd /tmp
    wget https://www.python.org/ftp/python/${vPython3}/Python-${vPython3}.tgz
    tar xvzf Python-${vPython3}.tgz
    cd Python-${vPython3}/
    ./configure
    #./configure --prefix=${sPythonBaseDir}/${sPython3name}
    #make
    make -j -l 4
    #sudo make install
    sudo make altinstall

    # link python3 and python3.x
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/bin/python3
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/local/bin/python3
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/bin/${sPython3name}
    sudo ln -sf ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name} /usr/local/bin/${sPython3name}

fi




#
# install setuptools as well as pip
#

# set module name
#sModuleName=python-setuptools

# install the module
#if [[ ! "$(type -P ${sModuleName})" ]]; then
  #e_header "Installing " ${sModuleName}
  #sudo apt-get -qq install ${sModuleName} -y
  #sudo easy_install pip
#fi




#
# FIX problem with pip and lsb_release by renaming file
#

# somehow pip has a problem when lsb_release is installed
# so, removing or renaming the file should solve the problem
# it can be re-activated by re-renaming or by re-installing
# "using apt-get install lsb-core"

#if [[ -d /usr/bin/lsb_release ]]; then
    #sudo mv /usr/bin/lsb_release /usr/bin/x_lsb_release
#fi




#
# install virtual environments
#

#e_header "Installing Virtual Environments"

# update configurations for current console
#source ~/.profile

# ENV for python v3 and update pip
#if [[ ! -d $HOME/.virtualenvs/${sPython3venv} ]]; then
    #mkvirtualenv ${sPython3venv} -p ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name}
    #sudo pip install -IU pip
    #deactivate
#fi
