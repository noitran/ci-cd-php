FROM php:7.2-fpm-alpine

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        build-base autoconf freetype-dev libpng-dev \
        libjpeg-turbo-dev freetype libpng libjpeg-turbo \
        git openssh supervisor nano g++ icu-dev openssl-dev \
        bzip2-dev cmake

## Install: RAR
RUN pecl install rar && \
    docker-php-ext-enable rar

## BCMath for Amqplib
RUN apk add --no-cache php7-bcmath && \
    docker-php-ext-install bcmath

## Install: ZIP
RUN docker-php-ext-install \
    zip

## Install: Opcache
RUN docker-php-ext-install \
    opcache

## Install: Redis
RUN pecl install redis && \
    docker-php-ext-enable redis

## Install: GD
RUN docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd

## Install: MongoDB
RUN pecl install mongodb && \
    docker-php-ext-enable mongodb

### Install: BZ2
RUN docker-php-ext-install bz2

## Other dependencies
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    intl \
    pcntl

## Install RabbitMQ amqp
RUN cd /tmp && \
    git clone https://github.com/alanxz/rabbitmq-c && cd rabbitmq-c/ && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -ENABLE_SSL_SUPPORT=OFF -BUILD_EXAMPLES=OFF .. && \
    cmake --build . --config Release --target install && \
    printf "/usr/local\n" | pecl install amqp && \
    cp /usr/local/lib64/lib* /usr/local/lib && \
    docker-php-ext-enable amqp && \
    cd /tmp && rm -rf rabbitmq-c

RUN apk del --no-cache \
        freetype-dev libpng-dev libjpeg-turbo-dev \
        autoconf g++ make cmake libxml2-dev coreutils \
    && rm -rf /var/log/* /var/cache/apk/* /tmp/*

RUN rm /etc/supervisord.conf && \
    mkdir -p /etc/supervisor/conf.d && \
    mkdir /var/log/supervisor && \
    mkdir /etc/supervisord.d

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./laravel.ini /usr/local/etc/php/conf.d
COPY ./xlaravel.pool.conf /usr/local/etc/php-fpm.d/
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf

WORKDIR /var/www
