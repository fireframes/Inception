FROM alpine:3.22

RUN apk add --no-cache \
            mariadb \
            mariadb-client && \
    mkdir -p /var/lib/mysql \
              /run/mysqld \
              /usr/local/bin && \
    chown -R mysql:mysql /var/lib/mysql \
                         /run/mysqld \
                         /usr/local/bin && \
    sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

COPY tools/init.sh /usr/local/bin/init.sh
COPY conf/me.cnf /etc/my.cnf.d/50-server.cnf

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT [ "init.sh" ]
