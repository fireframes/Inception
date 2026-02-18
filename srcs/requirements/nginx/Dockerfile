FROM alpine:3.22

RUN apk add --no-cache nginx openssl && \
    mkdir -p /var/www/html /etc/nginx/ssl && \
    chown -R nginx:nginx /var/lib/nginx /var/www/html /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 443
