FROM php:7.4-cli

RUN apt update
RUN apt install -y zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libicu-dev libxml2-dev \
                   libxslt1-dev libzip-dev

RUN docker-php-ext-install pdo_mysql intl soap xsl zip sockets bcmath

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd

RUN apt clean

COPY bin/composer-install.sh /root/
RUN chmod +x /root/composer-install.sh

RUN mkdir -p /root/.config/composer
RUN mkdir -p /root/.cache/composer

VOLUME /root/.config/composer
VOLUME /root/.cache/composer

WORKDIR /root

RUN ./composer-install.sh

RUN mv /root/composer.phar /usr/local/bin/composer

COPY composer/auth.json /root/.composer

WORKDIR /var/www/html
