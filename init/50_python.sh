#
## user settings (static)
#

# python versions
vPython2=2.7.10          # version number for python v2
sPython2name=python2.7   # name of python v2 installation in /opt
sPython2venv=python27    # name of python v2 virtual environment
vPython3=3.4.2           # version number for python v3
sPython3name=python3.4   # name of python v3 installation in /opt
sPython3venv=python34    # name of python v3 virtual environment




#
## install python versions from source as well as setuptools and pip
#

# install python v2 from source into /opt/
cd /tmp
wget https://www.python.org/ftp/python/${vPython2}/Python-${vPython2}.tgz
tar -zxvf Python-${vPython2}.tgz
cd Python-${vPython2}
#./configure
./configure --prefix=/opt/${sPython2name}
#make -j 4
make
sudo make install

# install python v3 from source into /opt/
cd /tmp
wget https://www.python.org/ftp/python/${vPython3}/Python-${vPython3}.tgz
tar xvzf Python-${vPython3}.tgz
cd Python-${vPython3}/
#./configure
./configure --prefix=/opt/${sPython3name}
make
sudo make install

# link python3 and python3.4 to v3.4 (not v3.2)
sudo ln -sf /opt/${sPython3name}/bin/${sPython3name} /usr/bin/python3
sudo ln -sf /opt/${sPython3name}/bin/${sPython3name} /usr/local/bin/python3
sudo ln -sf /opt/${sPython3name}/bin/${sPython3name} /usr/bin/${sPython3name}
sudo ln -sf /opt/${sPython3name}/bin/${sPython3name} /usr/local/bin/${sPython3name}

# install pip
#wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
#sudo python get-pip.py
sudo apt-get install python-setuptools -y
sudo easy_install pip




#
## install virtual environments
#

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
mkvirtualenv ${sPython2venv} -p /opt/${sPython2name}/bin/${sPython2name}
sudo pip install -IU pip
deactivate

# ENV for python v3 and update pip
mkvirtualenv ${sPython3venv} -p /opt/${sPython3name}/bin/${sPython3name}
sudo pip install -IU pip
deactivate
