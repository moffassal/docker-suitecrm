FROM php:5.6-apache
MAINTAINER Moffassal Hossain <moffassal@gmail.com>



COPY php.custom.ini /usr/local/etc/php/conf.d/
COPY config.php /var/www/html/

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libpng12-dev \
        libpq-dev \
        libxml2-dev \
        zlib1g-dev \
        libc-client-dev \
        libkrb5-dev \
        libldap2-dev \
        cron
RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
        curl \
        mbstring \
        mysqli \
        mysql \
        zip \
        ftp \
        pdo_pgsql \
        gd \
        fileinfo \
        soap \
        zip \
        imap \
        ldap

#Setting UP SuiteCRM
RUN curl -O https://codeload.github.com/salesagility/SuiteCRM/tar.gz/v7.7.9 && tar xvfz v7.7.9 --strip 1 -C /var/www/html
RUN chown www-data:www-data /var/www/html/ -R
RUN cd /var/www/html && chmod -R 755 .
RUN (crontab -l 2>/dev/null; echo "*    *    *    *    *     cd /var/www/html; php -f cron.php > /dev/null 2>&1 ") | crontab -

RUN apt-get clean

VOLUME /var/www/html/upload

WORKDIR /var/www/html
EXPOSE 80 443
