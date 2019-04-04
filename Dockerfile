FROM alpine

RUN apk add --update && \
    apk add --no-cache --upgrade \
    mc git composer curl openrc inotify-tools pwgen apache2 mariadb php7 php7-apache2 \
    php7-simplexml php7-session php7-json php7-phar php7-openssl php7-curl php7-mcrypt php7-pdo_mysql \
    php7-ctype php7-gd php7-xml php7-dom php7-iconv php7-phar php7-zip \
    mpd lame flac ffmpeg && \
    addgroup mysql mysql && \
    cd /var/www/localhost/htdocs/ && \
    rm -r * && \
    git clone -b $(curl --silent https://api.github.com/repos/ampache/ampache/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') --depth 1 https://github.com/ampache/ampache.git && \
    cd /var/www/localhost/htdocs/ && \
    mkdir /music && \
    mv ./ampache/* ./ && \
    rm -r ./ampache && \
    mkdir /var/temp && \
    cp -a ./config/. /var/temp/ && \
#    rm ./config/ampache.cfg.php.dist && \
    composer install --prefer-source --no-interaction && \
    find . -type f | grep -i "\.git" | xargs rm && \
    chown -R apache:apache /var/www && \
    chown -R apache:apache /media && \
    apk del git composer


COPY conf/ /

RUN chmod 755 /*.sh

EXPOSE 80

ENV MYSQL_ROOT_PASSWORD t00r

VOLUME  ["/etc/mysql", "/var/lib/mysql", "/music", "/var/www/localhost/htdocs/config", "/var/www/localhost/htdocs/themes"]
ENTRYPOINT ["/run.sh"]
