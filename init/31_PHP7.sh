#
## check for execution permission
#

is_raspbian || return 1




#
## install necessary packages
#

# define packages
packages=(
  php7.0
  php7.0-cli
  php7.0-curl
  php7.0-fpm
  php7.0-gd
  php7.0-hash
  php7.0-json
  php7.0-mbstring
  php7.0-mcrypt
  php7.0-mysqli
  php7.0-opcache
  php7.0-recode
  php7.0-xml
  php7.0-xmlprc
  php7.0-zip
  php7.0-zlib
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

# create backup of default site
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default-do-not-touch

# create PHP test site
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/index.php

# add index.php to default index files
sudo sed -i -r 's|index index\.html|index index\.php index\.html|g' /etc/nginx/sites-available/default

# uncomment fast cgi blocks
sudo sed -i -r 's|#location ~ \\.php\$|location ~ \\.php\$|g' /etc/nginx/sites-available/default
sudo sed -i -r 's|#\sfastcgi_pass unix|fastcgi_pass unix|g' /etc/nginx/sites-available/default

# add fast cgi path info
sudo sed -i -r '/location ~ \\.php\$/a fastcgi_split_path_info \^\(\.\+\\.php\)(\/\.\+\)\$;' /etc/nginx/sites-available/default
sudo sed -i -r '/fastcgi_pass unix/a }' /etc/nginx/sites-available/default
sudo sed -i -r '/fastcgi_pass unix/a fastcgi_index index\.php;' /etc/nginx/sites-available/default
sudo sed -i -r '/fastcgi_pass unix/a include fastcgi\.conf;' /etc/nginx/sites-available/default




#
# restart
#

sudo /etc/init.d/nginx restart
sudo /etc/init.d/php7.0-fpm restart
