#
# set source code path settings
#

prjname="invoiceplane"
prjpath="pi@192.168.1.49:/home/pi/usbdrv/_python/APP__$prjname.git"
current_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/')

sitepath="/etc/nginx/sites-available"
enablepath="/etc/nginx/sites-enabled"
wwwpath="/var/www/invoiceplane"
wwwuser="www-data"




#
# configure NGINX
#

# shut down any other web service
sudo service apache2 stop

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
# configure MARIADB
#

# secure the database
#sudo mysql_secure_installation

# login to database system
#...

# create database
#...

# create user
#...

# grant full access to user
#...

# save and exit
#...




#
# get and prepare application
#

# download zip file from project site
wget -c -O v1.5.9.zip https://invoiceplane.com/download/v1.5.9

# unzip into local temporary folder
unzip v1.5.9

# move unzipped files into web folder
sudo mv ip $wwwpath

# rename a couple of commands
cd $wwwpath
sudo cp ipconfig.php.example ipconfig.php
sudo cp htaccess .htaccess

# insert IP into applications ip configuration
sudo sed -i -r "s|IP_URL=.*|IP_URL=http://$current_ip|g" $wwwpath/ipconfig.php

# provide necessary permissions
sudo chown -R $wwwuser:$wwwuser $wwwpath/
sudo chmod -R 755 $wwwpath/

# create NGINX site configuration
cat >$sitepath/$prjname <<EOF
server {
    listen 80;
    listen [::]:80;
    root /var/www/$prjname;
    index index.php index.html index.htm;
    server_name $current_ip;
    client_max_body_size 100M;

    location / {
        try_files \$uri \$uri/ /index.php?q=\$uri\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

# disable all other possible sites
sudo rm $enablepath/.

# enable site
sudo ln -s $sitepath/$prjname $enablepath/

