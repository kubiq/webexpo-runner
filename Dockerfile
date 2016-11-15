
FROM chrert/docker-arch-yaourt:latest

MAINTAINER Jakub Pistek <mail@jakubpistek.cz>

# Environment
ENV TESTER_PATH /srv/tester/
ENV TESTER_BIN /srv/tester/vendor/bin/tester
ENV APP_PATH /srv/app/

ADD archlinuxfr.repo /root/archlinuxfr.repo
RUN cat /root/archlinuxfr.repo >> /etc/pacman.conf

# Install PHP, git...
RUN pacman --noconfirm -Sy archlinux-keyring \
  && pacman --noconfirm -Su \
    base-devel \
    openssh \
    git \
    php-fpm \
    php-memcached \
    php-sqlite \
    php-gd \
    php-apcu \
    php-cgi \
    qrencode \
    unzip \
    yaourt

USER yaourt
RUN yaourt -S --noconfirm php-imagick
USER root

# enable some php libs
RUN sed -i.bak 's/^;extension=iconv.so/extension=iconv.so/' /etc/php/php.ini \
 && sed -i.bak 's/^;extension=gd.so/extension=gd.so/' /etc/php/php.ini \
 && sed -i.bak 's/^;extension=pdo_mysql.so/extension=pdo_mysql.so/' /etc/php/php.ini

# Install Composer, Nette Tester
RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  mkdir $TESTER_PATH && mkdir $APP_PATH && \
  composer require nette/tester:~1.6.0 -d $TESTER_PATH

# Volumes
VOLUME $APP_PATH
