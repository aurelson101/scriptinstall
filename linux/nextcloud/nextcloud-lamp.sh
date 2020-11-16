#!/bin/sh
###############################################################################
## This script will install NextCloud on Debian/Ubuntu as follows:                ##
## php-fpm using unixsocket and own fpm pool for isolation                   ##
## Apache2 using MPM Event (should be a least as fast as nginx)              ##
## Redis though unixsocket  for memory local cache                           ##
## Redis though  unixsocket for memory locking cache                         ##
## Data eviction is using intellegent LRU for cache.			     ##
## SSL using Lets Encrypt with secure TLS defaluts. A+ Rating                ##
###############################################################################

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

nextcloudVersion="nextcloud-20.0.1.zip"

echo "User Pwd name For SQL"
read -p "Add User: " db_user
read -p "Add Name DB: " db_name
read -p "Entrer Password: " db_pw

echo "Domain for nextcloud"
read -p "ex cloud.test.net: " domainname

echo "Add Your Email"
read -p "Entrer Password: " email

# The amount of cache used by Redis for locking and file cache.
# Will use LRU when full for intelligent data eviction. This can
# be adjusted for your systems RAM.
redis_max_mem='0.5G'

echo "Update System"
apt-get update -y && apt-get upgrade -y

echo "Install curl wget unzip"
apt install curl wget unzip -y

echo "Install apache and php"
apt-get install apache2 php -y
PHPV=$(php -r "echo PHP_VERSION;" | grep --only-matching --perl-regexp "7.\d+")

echo "Install PHP"
apt install libapache2-mod-php$PHPV php$PHPV-gd php$PHPV-json php$PHPV-mysql php$PHPV-curl php$PHPV-mbstring php$PHPV-intl php-imagick php$PHPV-xml php$PHPV-zip -y

echo "edit variable PHP"
sed -i 's/;date.timezone =/date.timezone = Europe/Paris/g' /etc/php/$PHPV/apache2/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/$PHPV/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 500M/g' /etc/php/$PHPV/apache2/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 500M/g' /etc/php/$PHPV/apache2/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/$PHPV/apache2/php.ini

echo "Setup MariaDB"
apt-get install mariadb-server -y

mysql_secure_installation
mysql -e "CREATE DATABASE $db_name;"
mysql -e "CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pw';"
mysql -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "quit"


echo "Download NextCloud"
cd /tmp || { printf 'There is no /tmp dir\n'; exit 1; }
wget "https://download.nextcloud.com/server/releases/$nextcloudVersion"

unzip $nextcloudVersion
mv nextcloud /var/www/
chown -R www-data:www-data /var/www/nextcloud

# Sets up the vhost
cat >/etc/apache2/sites-available/nextcloud.conf<<EOF
<VirtualHost *:80>
    	ServerAdmin $email
        DocumentRoot "/var/www/nextcloud"
        ServerName apps.aurelson.com
    	ServerName $domainname
        ErrorLog ${APACHE_LOG_DIR}/nextcloud.error
        CustomLog ${APACHE_LOG_DIR}/nextcloud.access combined

        <Directory /var/www/nextcloud/>
            Require all granted
            Options FollowSymlinks MultiViews
            AllowOverride All

           <IfModule mod_dav.c>
               Dav off
           </IfModule>

        SetEnv HOME /var/www/nextcloud
        SetEnv HTTP_HOME /var/www/nextcloud
        Satisfy Any

       </Directory>

RewriteEngine on
RewriteCond %{SERVER_NAME} =$domainname
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>
EOF

echo "enable site and module"
a2ensite nextcloud.conf
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
a2enmod ssl
systemctl reload apache2



echo "Redis for distributed caching on unixsocket"
apt-get install php$PHPV-redis redis-server -y

#echo "Generate pw for redis connection"
#redis_pw="$(tr -cd '[:alnum:]' < /dev/urandom | fold -w32 | head -n1)"

#sed -i "s/# requirepass foobared/requirepass ${redis_pw}/g" /etc/redis/redis.conf
#sed -i 's/port 6379/port 0/g' /etc/redis/redis.conf
#sed -i 's/# unixsocket/unixsocket/g' /etc/redis/redis.conf
#sed -i 's/unixsocketperm 700/unixsocketperm 770/g' /etc/redis/redis.conf

usermod -a -G redis www-data
#chown -R redis:www-data /var/run/redis

systemctl reload apache2
systemctl enable redis-server
systemctl start redis-server
  
## Setting up Redis data eviction policies in redis.conf for LRU allkeys
cat >>/etc/redis/redis.conf<<EOF
maxmemory "$redis_max_mem"
maxmemory-policy allkeys-lru
maxmemory-samples 5
EOF

systemctl enable redis-server

# Zend opcache for PHP script cache
cat >>/etc/php/7.0/mods-available/opcache.ini<<EOF
opcache.enable=1
opcache.enable_cli=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=1
EOF

systemctl reload apache2
systemctl restart redis-server.service

## Setup SSL using Lets Encrypt
apt install python-certbot-apache -y

sudo certbot --authenticator standalone --installer apache \
  --redirect -d "$domainname" --rsa-key-size 4096 --must-staple \
  --hsts --uir --staple-ocsp --strict-permissions --email "$email" \
  --agree-tos --pre-hook "service apache2 stop" \
  --post-hook "service apache2 start" -n

# Auto renew cert
crontab -l > certbot
echo '0 0 * * 0 /usr/bin/certbot renew' >> certbot
crontab certbot
rm certbot

echo "dont forget to read helpme.txt"
