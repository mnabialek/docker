#!/bin/sh

# SSH - this would be useful when need to log in using password (123 here is root password)
echo 'root:123' | chpasswd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH - login using SSH keys - copy public SSH key to authorized_keys
mkdir /root/.ssh
chmod 700 /root/.ssh
cat /root/.local_share/ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Save Github Oauth token to prevent limits when using Composer
composer config -g github-oauth.github.com $(cat /root/.local_share/tokens/github-oauth)

# Run PHP service
service php7.1-fpm start

# Disable Xdebug for command line
phpdismod -s cli xdebug

# Start supervisor
supervisord -n
