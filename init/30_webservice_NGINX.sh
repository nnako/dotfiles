#
## check for execution permission
#

is_raspbian || return 1




#
## install necessary packages
#

# define packages
packages=(
  nginx
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
## set some configutations
#

# prevent PRi from overload
sudo sed -i "s/worker_processes 4;/worker_processes 1;/g" /etc/nginx/nginx.conf
sudo sed -i "s/worker_connections 768;/worker_connections 128;/g" /etc/nginx/nginx.conf

# start NGINX service
sudo /etc/init.d/nginx start
