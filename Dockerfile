
FROM finalduty/archlinux:weekly

MAINTAINER Jakub Pistek <mail@jakubpistek.cz>

# Environment
ENV TESTER_PATH /srv/tester/
ENV TESTER_BIN /srv/tester/vendor/bin/tester
ENV APP_PATH /srv/app/

# Install PHP, git...
RUN pacman --noconfirm -Syu \
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
    xdebug \
    sudo

ADD inst_yaourt.sh inst_yaourt.sh
RUN sh -x ./inst_yaourt.sh

USER user
RUN yaourt -S --noconfirm php-imagick php-redis composer
USER root

# Install Composer, Nette Tester
RUN mkdir $TESTER_PATH && mkdir $APP_PATH \
 && composer require nette/tester:~1.6.0 -d $TESTER_PATH

# Volumes
VOLUME $APP_PATH
