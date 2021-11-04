# install NextCloud Client from debian packages
# from: https://help.nextcloud.com/t/nextcloud-client-for-raspberry-pi/27989/62




#
# get required packages
#

# define packages
packages=(
  q/qtwebengine-opensource-src/libqt5webenginecore5_5.11.3+dfsg-2+deb10u1_armhf.deb
  q/qtwebengine-opensource-src/libqt5webenginewidgets5_5.11.3+dfsg-2+deb10u1_armhf.deb
  n/nextcloud-desktop/libnextcloudsync0_2.5.1-3+deb10u2_armhf.deb
  n/nextcloud-desktop/nextcloud-desktop_2.5.1-3+deb10u2_armhf.deb
)
# DOES NOT WORK
  #q/qtwebengine-opensource-src/libqt5webenginecore5_5.15.6+dfsg-2+b1_armhf.deb
  #q/qtwebengine-opensource-src/libqt5webenginewidgets5_5.15.6+dfsg-2+b1_armhf.deb
  #n/nextcloud-desktop/libnextcloudsync0_3.3.5-1_armhf.deb
  #n/nextcloud-desktop/nextcloud-desktop_3.3.5-1_armhf.deb

# WORKS
  #q/qtwebengine-opensource-src/libqt5webenginecore5_5.11.3+dfsg-2+deb10u1_armhf.deb
  #q/qtwebengine-opensource-src/libqt5webenginewidgets5_5.11.3+dfsg-2+deb10u1_armhf.deb
  #n/nextcloud-desktop/libnextcloudsync0_2.5.1-3+deb10u1_armhf.deb
  #n/nextcloud-desktop/nextcloud-desktop_2.5.1-3+deb10u1_armhf.deb

# download packages
if (( ${#packages[@]} > 0 )); then
  e_header "Downloading DEB packages\n${packages[*]}"
  for package in "${packages[@]}"; do
    #wget https://debian.pkgs.org/10/debian-main-armhf/${package}.html
    wget http://ftp.br.debian.org/debian/pool/main/${package}
  done
fi

# install using dpkg
if (( ${#packages[@]} > 0 )); then
  e_header "Installing DEB packages\n${packages[*]}"
  for package in "${packages[@]}"; do
    # install each package
    sudo dpkg -i "${package##*/}"
    # handle broken dependencies
    sudo apt -y --fix-broken install
  done
fi

