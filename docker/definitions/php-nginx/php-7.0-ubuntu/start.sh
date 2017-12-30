#!/bin/sh

# SSH - this would be useful when need to log in using password (123 here is root password)
echo 'root:123' | chpasswd
sed -i 's/PermitRootLogin prohibit\-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Allow www-data user to log in
sed -i 's#www-data:/var/www:/usr/sbin/nologin#www-data:/www-data:/bin/bash#' /etc/passwd6 
# Set www-data password (123 here is www-data user password)
echo 'www-data:123' | chpasswd

# SSH - login using SSH keys - copy public SSH key to authorized_keys
mkdir /www-data/.ssh
chmod 700 /www-data/.ssh
cat /www-data/.local_share/ssh/id_rsa.pub >> /www-data/.ssh/authorized_keys
chmod 600 /www-data/.ssh/authorized_keys

# Save Github Oauth token to prevent limits when using Composer
composer config -g github-oauth.github.com $(cat /www-data/.local_share/tokens/github-oauth)

# Run PHP service
service php7.0-fpm start

# Run Nginx service
service nginx start

# Run Cron
mkdir /www-data/.cron
crontab /www-data/.cron/www-data
service cron start

# Run redis
service redis-server start

# Disable Xdebug for command line
phpdismod -s cli xdebug

# Start supervisor
supervisord -n