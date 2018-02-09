# Base image
FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive

# Update packages list and system
RUN apt-get -y update
RUN apt-get -y upgrade

# Allow to use add-apt-repository command
RUN apt-get -y install software-properties-common locales poppler-utils

# Set valid lcoale
RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
RUN locale-gen en_US.UTF-8

# Add some packages
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
RUN apt-add-repository ppa:chris-lea/redis-server -y
RUN apt-add-repository ppa:nginx/development -y
RUN apt-key update
RUN apt-get -y update

# Install basic packages
RUN apt-get -y install git mc unzip nano

# Install Libxml2 to install Soap PHP extension
RUN apt-get install -y libxml2-dev

# Install Zlib to install Zip PHP extension
RUN apt-get install -y zlib1g-dev

# Install PHP
RUN apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php5.6-cli php5.6-fpm php5.6-dev \
php5.6-pgsql php5.6-sqlite3 php5.6-gd \
php5.6-curl php5.6-memcached \
php5.6-imap php5.6-mysql php5.6-mbstring \
php5.6-xml php5.6-zip php5.6-bcmath php5.6-soap \
php5.6-intl php5.6-readline php-xdebug php-pear

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install SSH server
RUN apt-get --yes install openssh-server
RUN mkdir /var/run/sshd

# Install Nginx
RUN apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default
RUN service nginx restart

# Set The Nginx & PHP-FPM User
RUN sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

# Install supervisor (using easy_install to get latest version)
RUN apt-get install --yes python-setuptools
RUN easy_install supervisor
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN mkdir /etc/supervisor/

# Set up supervisor log and include extra configuration files
RUN sed -i -e "s#logfile=/tmp/supervisord.log ;#logfile=/var/log/supervisor/supervisord.log ;#g" /etc/supervisord.conf
RUN sed -i -e "s#;\[include\]#\[include\]#g" /etc/supervisord.conf
RUN sed -i -e "s#;files = relative/directory/\*.ini#files = /etc/supervisor/conf.d/\*.conf#g" /etc/supervisord.conf

# Set PHP to listen on given port instead of unix socket
RUN sed -i -e 's#listen = \/run\/php\/php5.6-fpm.sock#listen = 0.0.0.0:9000#g' /etc/php/5.6/fpm/pool.d/www.conf

# Set xdebug options
RUN echo "xdebug.remote_enable = 1" >> /etc/php/5.6/mods-available/xdebug.ini
RUN echo "xdebug.remote_connect_back = 1" >> /etc/php/5.6/mods-available/xdebug.ini
RUN echo "xdebug.remote_port = 9999" >> /etc/php/5.6/mods-available/xdebug.ini
RUN echo "xdebug.max_nesting_level = 512" >> /etc/php/5.6/mods-available/xdebug.ini
RUN echo "xdebug.profiler_output_dir=\"\"" >> /etc/php/5.6/mods-available/xdebug.ini
RUN echo "xdebug.profiler_enable_trigge=1" >> /etc/php/5.6/mods-available/xdebug.ini

# Set PHP options
RUN sed -i "s/error_reporting = .*/error_reporting = -1/" /etc/php/5.6/fpm/php.ini
RUN sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/fpm/php.ini
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/5.6/fpm/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 2048M/" /etc/php/5.6/fpm/php.ini
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/5.6/fpm/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/5.6/fpm/php.ini

# Install Chrome web driver and other libraries required to run Laravel Dusk tests
RUN apt-get -y install libxpm4 libxrender1 libgtk2.0-0 \
libnss3 libgconf-2-4 chromium-browser \
xvfb gtk2-engines-pixbuf xfonts-cyrillic \
xfonts-100dpi xfonts-75dpi xfonts-base \
xfonts-scalable imagemagick x11-apps

# Install Redis
RUN apt-get -y install redis-server

# Clean
RUN apt-get -y autoremove
RUN apt-get -y clean

# Copy .bashrc and .profile files
COPY .bashrc /www-data/.bashrc
COPY .profile /www-data/.profile

# Copy services script file
COPY start.sh /www-data/start.sh

# Run services file
CMD ["/bin/bash", "/www-data/start.sh"]