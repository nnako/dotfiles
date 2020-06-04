#
# settings
#

strAppName=APP__nextcloud_client




#
# get required packages
#

# define packages
packages=(
  git
  libsqlite3-dev
  qt5-default
  libqt5webkit5-dev
  qt5keychain-dev
  cmake
  build-essential
  libowncloudsync0
  libssl1.0-dev
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
# get and build the application
#

#git clone https://github.com/nextcloud/client_theming.git $strAppName
#cd $strAppName
#git submodule update --init --recursive
#mkdir build-linux
#cd build-linux
#cmake -D OEM_THEME_DIR=$(realpath ../nextcloudtheme) -DCMAKE_INSTALL_PREFIX=/usr  ../client
#make
#sudo make install

# get and install from new location
git clone https://github.com/nextcloud/desktop.git ${strAppName}_SOURCE
cd ${strAppName}_SOURCE
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=~/$strAppName -DCMAKE_BUILD_TYPE=Debug -DNO_SHIBBOLETH=1
make install
