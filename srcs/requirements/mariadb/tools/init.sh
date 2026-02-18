#!/bin/sh
set -e

# Initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "===> Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily for setup
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"
    
    # Wait for MariaDB to be ready
    echo "===> Waiting for MariaDB to start..."
    i=30
    while [ $i -gt 0 ]; do
        if mysql -u root -e 'SELECT 1' > /dev/null 2>&1; then
            break
        fi
        sleep 1
        i=$(($i - 1))
    done
    
    if [ "$i" = 0 ]; then
        echo "===> MariaDB failed to start"
        exit 1
    fi
    
    echo "===> Setting up root password and creating database..."
    
    # Secure installation and create user/database
    mysql -u root <<-EOSQL
		DELETE FROM mysql.user WHERE User='';
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
		
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		
		FLUSH PRIVILEGES;
	EOSQL
    
    # Stop temporary instance
    if ! mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown; then
        echo "===> Failed to stop temporary MariaDB"
        exit 1
    fi
    
    echo "===> MariaDB initialization complete"
fi

# Start MariaDB in foreground
echo "===> Starting MariaDB..."
exec mysqld --user=mysql --console
