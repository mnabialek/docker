#!/bin/sh

# Copy MySQL conf files into valid directory - it does the trick with 777 permissions on Windows hosts
cp /etc/mysql/conf.d/source/* /etc/mysql/conf.d/

# Set timezone
export TZ="Europe/Warsaw"

# Start MySQL server (using default MySQL entrypoint)
/entrypoint.sh mysqld