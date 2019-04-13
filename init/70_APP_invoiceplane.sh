#
# set source code path settings
#

prjname="APP__invoiceplane"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/$prjname.git"

# move into Python v2 virtual environment
#workon $sPython2venv




#
# configure NGINX
#

# prevent PRi from overload
sudo sed -i "s/worker_processes 4;/worker_processes 1;/g" /etc/nginx/nginx.conf
sudo sed -i "s/worker_processes auto;/worker_processes 1;/g" /etc/nginx/nginx.conf
sudo sed -i "s/worker_connections 768;/worker_connections 128;/g" /etc/nginx/nginx.conf

# start NGINX service
sudo /etc/init.d/nginx start




#
# configure PHP
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

# restart services
sudo /etc/init.d/nginx restart
sudo /etc/init.d/php7.0-fpm restart




#
# configure MARIABD
#

# secure the database
sudo mysql_secure_installation





#
# get and prepare application
#

# get project source code (if not already present)
#if [[ ! -d "$HOME/$prjname" ]]; then
    #git clone $prjpath $HOME/$prjname
#fi

# move into project folder
#cd $HOME/$prjname

# create temporary project folder (if not existent)
#if [[ ! -d "$HOME/.$prjname" ]]; then
    #mkdir $HOME/.$prjname
#fi




#
# get relevant packages (if not already present)
#

#sudo apt-get -qq install python-pip
#sudo apt-get -qq install python-dev
#sudo apt-get -qq install libxml2-dev
#sudo apt-get -qq install libxslt1-dev
#sudo apt-get -qq install zlib1g-dev
#sudo apt-get -qq install libffi-dev
#sudo apt-get -qq install libyaml-dev
#sudo apt-get -qq install libssl-dev
#sudo apt-get -qq install libsasl2-dev
#sudo apt-get -qq install libldap2-dev
