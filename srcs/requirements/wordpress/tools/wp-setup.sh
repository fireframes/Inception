#!/bin/sh
set -e

# Ensure installation happens in the web root
cd /var/www/html

# 1. FIX: Increase memory limit for the current script execution
export PHP_INI_SCAN_DIR=/etc/php82/conf.d
echo "memory_limit=512M" > /etc/php82/conf.d/memory-fix.ini

echo "Waiting for MariaDB..."
while ! mariadb-admin ping -h"mariadb" -u $MYSQL_USER -p$MYSQL_PASSWORD --silent; do
    sleep 1
done

# 2. FIX: Check for wp-login.php instead of index.php (more reliable)
if [ ! -f "wp-login.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

if [ ! -f "wp-config.php" ]; then
    echo "Configuring WordPress..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
fi

echo "Setting permissions..."
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm82 -F