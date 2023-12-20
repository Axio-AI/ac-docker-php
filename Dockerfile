FROM php:7.2-fpm

RUN apt-get update \
  && apt-get install --no-install-recommends -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    default-mysql-client pv wget psmisc procps \
    redis-tools curl git nano sudo \
    software-properties-common libmcrypt-dev \
    libmagickwand-dev zip iputils-ping \
    libmemcached-dev libzip-dev nginx htop supervisor \
  && apt-get clean

RUN pecl install imagick \
  && docker-php-ext-enable imagick \
  && pecl install mcrypt-1.0.4 \
  && docker-php-ext-enable mcrypt \
  && docker-php-ext-install gd \
  && docker-php-ext-install sockets \
  && pecl install memcached \
  && docker-php-ext-enable memcached \
  && docker-php-ext-configure opcache --enable-opcache \
  && docker-php-ext-install opcache \
  && docker-php-ext-install -j$(nproc) iconv \
  && docker-php-ext-install bcmath \
  && docker-php-ext-install exif \
  && docker-php-ext-install pcntl \
  && docker-php-ext-install pdo_mysql \
  && docker-php-ext-install soap \
  && docker-php-ext-install zip \
  && pecl install redis \
  && docker-php-ext-enable redis.so \
  # && pecl install xdebug-3.1.6 \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && rm -rf /tmp/pear /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.d/www.conf*

COPY config/*.ini $PHP_INI_DIR/conf.d/
COPY config/fpm/www.conf /usr/local/etc/php-fpm.d

WORKDIR /var/www/api
