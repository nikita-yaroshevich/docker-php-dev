FROM php:5.6-apache

RUN apt-get update \
    && apt-get install -y --fix-missing git libssl-dev zlib1g-dev libicu-dev g++ mcrypt php-pear php5-apcu\
    libfreetype6-dev \
 #   php5-imagick \
    libjpeg62-turbo-dev \
 #   libmagickcore-dev \
 #   libmagickwand-dev \
    libmcrypt-dev \
    imagemagick\
    libpng12-dev \
    php5-xsl \
    libcurl4-openssl-dev \
    nano \

#    && apt-get -y install libmagick9-dev \
    && pecl install mongo \
    && echo extension=mongo.so > /usr/local/etc/php/conf.d/mongo.ini \
    && pecl install xdebug \
    && echo zend_extension=xdebug.so > /usr/local/etc/php/conf.d/xdebug.ini \
    && docker-php-ext-install zip mbstring intl gd mcrypt pdo pdo_mysql mysqli

    # ImageMagick need to setup
#RUN apt-get install --fix-missing -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*  && \
#    curl -L https://pecl.php.net/get/imagick-3.3.0RC2.tgz >> /usr/src/php/ext/imagick.tgz && \
#    tar -xf /usr/src/php/ext/imagick.tgz -C /usr/src/php/ext/ && \
#    rm /usr/src/php/ext/imagick.tgz

#RUN docker-php-ext-install imagick-3.3.0RC2 

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP staff
ENV APACHE_LOG_DIR /var/log/apache2
ENV ENVIRONMENT docker



RUN a2enmod ssl rewrite \
 && export TERM=xterm \
 && mkdir /root/.ssh/ \
 && php5enmod xsl

RUN usermod -u 1000 www-data 

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer

ADD docker/vhost.conf /etc/apache2/sites-enabled/000-default.conf 
ADD docker/php.ini /usr/local/etc/php/php.ini

RUN mkdir -p /var/www/apps/
WORKDIR /var/www/apps/

VOLUME ["/var/www/", "/var/log/apache2/"]
