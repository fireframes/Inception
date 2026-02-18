FROM alpine:3.22

RUN apk add --no-cache curl \
                       php82 \
                       php82-fpm \
                       php82-mysqli \
                       php82-phar \
                       php82-iconv \
                       php82-mbstring \
                       mariadb-client && \
    ln -s /usr/bin/php82 /usr/bin/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php82/php.ini

COPY ./tools/wp-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-setup.sh && \
    mkdir /run/php

EXPOSE 9000

ENTRYPOINT ["wp-setup.sh"]
