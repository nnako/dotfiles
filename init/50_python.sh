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




# leave virtual environment if possible
#...




#
## install python version v2 from source
#

if [[ ! -d $sPythonBaseDir/$sPython2name ]]; then

    e_header "Installing Python v${vPython2} from source into ${sPythonBaseDir}"

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

fi




#
## install python version v3 from source
#

if [[ ! -d $sPythonBaseDir/$sPython3name ]]; then

    e_header "Installing Python v${vPython3} from source into ${sPythonBaseDir}"

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

#wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
#sudo python get-pip.py
sudo apt-get install python-setuptools -y
sudo easy_install pip




#
## install virtual environments
#

e_header "Installing Virtual Environments"

# install packages
sudo pip install virtualenv
sudo pip install virtualenvwrapper

# insert necessary rows into .profile file
sed -i -e '/^WORKON_HOME\b/d' $HOME/.profile
echo "" >> $HOME/.profile
echo "# settings for virtualenv" >> $HOME/.profile
echo "WORKON_HOME=$HOME/.virtualenvs" >> $HOME/.profile
sed -i -e '/^PROJECT_HOME\b/d' $HOME/.profile
echo "PROJECT_HOME=$HOME/PRJ" >> $HOME/.profile
sed -i -e '/source \/usr\/local\/bin\/virtualenvwrapper.sh/d' $HOME/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> $HOME/.profile
source $HOME/.profile

# ENV for python v2 and update pip
mkvirtualenv ${sPython2venv} -p ${sPythonBaseDir}/${sPython2name}/bin/${sPython2name}
sudo pip install -IU pip
deactivate

# ENV for python v3 and update pip
mkvirtualenv ${sPython3venv} -p ${sPythonBaseDir}/${sPython3name}/bin/${sPython3name}
sudo pip install -IU pip
deactivate
