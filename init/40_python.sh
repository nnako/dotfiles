#
# install additional tools for python
#

# define packages
packages=(
    python-pip
    python3-pip
    python3-venv
)
    #python3-picamera

# filter packages which have already been installed
packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

# install using apt-get
if (( ${#packages[@]} > 0 )); then
  e_header "Installing APT packages\n${packages[*]}"
  for package in "${packages[@]}"; do
    sudo apt -qq install "$package"
  done
fi

