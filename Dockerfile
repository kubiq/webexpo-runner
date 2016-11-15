# Based on Debian Jessie
FROM debian:jessie

# Environment
ENV TESTER_PATH /srv/tester/
ENV TESTER_BIN /srv/tester/vendor/bin/tester
ENV APP_PATH /srv/app/

ADD dotdeb.gpg /root/dotdeb.gpg

RUN apt-key add /root/dotdeb.gpg
RUN echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list.d/dotdeb.list

# Install PHP, cURL, Git
RUN apt-get update -qqy \
  && apt-get -qqy install \
    php7.0-fpm \
    php7.0-redis \
    php7.0-curl \
    php7.0-memcached \
    php7.0-mysql \
    php7.0-sqlite \
    php7.0-gd \
    php7.0-apcu \
    php7.0-curl \
    php7.0-imagick \
    php7.0-mbstring \
    php7.0-xml \
    php7.0-simplexml \
    php7.0-zip \
    php7.0-cgi \
    ca-certificates \
    curl \
    git \
    locales-all \
    qrencode \
    unzip

# Install Composer, Nette Tester
RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  mkdir $TESTER_PATH && mkdir $APP_PATH && \
  composer require nette/tester:~1.6.0 -d $TESTER_PATH

# Clean image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Volumes
VOLUME $APP_PATH
