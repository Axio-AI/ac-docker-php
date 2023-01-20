FROM php:7.2-fpm

RUN apt-get update
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
                        default-mysql-client pv wget psmisc procps \
                        redis-tools curl git nano sudo \
                        software-properties-common libmcrypt-dev \
                        libmagickwand-dev zip iputils-ping \
                        libmemcached-dev libzip-dev nginx htop supervisor

# Install imagick
RUN pecl install imagick
RUN docker-php-ext-enable imagick

# Install mcrypt
RUN pecl install mcrypt-1.0.4
RUN docker-php-ext-enable mcrypt

# Install gd
RUN docker-php-ext-install gd

# Install memcached
RUN pecl install memcached
RUN docker-php-ext-enable memcached

# Install
RUN docker-php-ext-configure opcache --enable-opcache
RUN docker-php-ext-install opcache
COPY config/opcache.ini $PHP_INI_DIR/conf.d/

# Install EXT
RUN docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install exif
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install soap
RUN docker-php-ext-install zip

# Install xdebug
RUN pecl install xdebug-3.1.6
# RUN docker-php-ext-enable xdebug
ADD ./config/xdebug.ini $PHP_INI_DIR/conf.d

# Custom DEV Config
ADD ./config/laravel.ini $PHP_INI_DIR/conf.d

# Configure php-fpm config
RUN rm /usr/local/etc/php-fpm.conf.default
RUN rm /usr/local/etc/php-fpm.d/www.conf*

ADD ./config/fpm/www.conf /usr/local/etc/php-fpm.d

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/nb-api
