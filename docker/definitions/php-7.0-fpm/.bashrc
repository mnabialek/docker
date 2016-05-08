# Display full hostname in prompt
export PS1="\u@\H:\w\$"

# Set timezone
export TZ="Europe/Warsaw"

# Set TERM env - it will be needed for using some packages
export TERM="xterm"

# Set long timeout for Composer (otherwise we might get timeouts when installing some repos)
export COMPOSER_PROCESS_TIMEOUT=2000

# We will run Composer as root and don't want this warning
export COMPOSER_ALLOW_SUPERUSER=1

# We want to run Composer without Xdebug enabled to make it quicker
alias composer="php -n /usr/local/bin/composer"

# Fix for MC (actually ncurses) to display lines properly
export LANG="C.UTF-8"

# Alias for Artisan
alias artisan="php artisan"

# Alias for PHPUnit
alias phpunit="vendor/bin/phpunit"

# Start in website directory by default
cd /usr/share/nginx/html/