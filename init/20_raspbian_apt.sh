#
# check for execution permission
#

is_raspbian || return 1




#
# define list of desired packages
#

# define packages
packages=(
  build-essential
  libncursesw5-dev
  libevent-dev
  libgdbm-dev
  libc6-dev
  zlib1g-dev
  libsqlite3-dev
  tk-dev
  libssl-dev
  openssl
  htop
  nmap
  tree
  feh
  zathura
  lynx
  tmux
  vifm
  imagemagick
  gimp
)
  #ranger




#
# install chosen packages
#

# filter packages which have already been installed
packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

# install using apt-get
if (( ${#packages[@]} > 0 )); then
  e_header "Installing SYSTEM PACKAGES and APPLICATIONS\n${packages[*]}"
  for package in "${packages[@]}"; do
    #sudo apt-get -qq install "$package"
    sudo apt -qq install "$package"
  done
fi




#
# global git parameters
#

e_header "Configure NNAKO as GIT USER"

# email
git config --global user.email "nnako@web.de"

# name
git config --global user.name "nnako"




#
# rename device
#

#...
