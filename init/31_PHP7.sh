#
# check for execution permission
#

is_raspbian || return 1




#
# install necessary packages
#

# define packages
packages=(
  php7.0
  php7.0-cli
  php7.0-curl
  php7.0-fpm
  php7.0-gd
  php7.0-json
  php7.0-mbstring
  php7.0-mcrypt
  php7.0-mysqli
  php7.0-opcache
  php7.0-recode
  php7.0-xml
  php7.0-zip
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
