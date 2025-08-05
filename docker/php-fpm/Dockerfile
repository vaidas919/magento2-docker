FROM php:7.4-fpm

RUN apt update
RUN apt install -y libcurl4-openssl-dev zlib1g-dev libpng-dev libicu-dev libmcrypt-dev libxml2-dev \
                   libjpeg-dev libfreetype6-dev libzip-dev libxslt1-dev sasl2-bin sendmail
RUN docker-php-ext-install curl intl xsl pdo_mysql soap zip sockets bcmath
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN apt clean

RUN pecl channel-update pecl.php.net
RUN pecl install mcrypt
    RUN touch /usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini
RUN echo "extension=mcrypt.so" >> /usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini

COPY smtp-auth-creds /etc/mail
RUN makemap hash /etc/mail/smtp-auth-creds < /etc/mail/smtp-auth-creds

COPY sendmail.mc-part /root

RUN sed -i '/divert(0)dnl/r /root/sendmail.mc-part' /etc/mail/sendmail.mc

RUN make -C /etc/mail

COPY bin/composer-install.sh /root/
RUN chmod +x /root/composer-install.sh

RUN mkdir -p /root/.config/composer
RUN mkdir -p /root/.cache/composer

VOLUME /root/.config/composer
VOLUME /root/.cache/composer

WORKDIR /root

RUN ./composer-install.sh

RUN mv /root/composer.phar /usr/local/bin/composer

VOLUME /var/www/html

COPY composer/auth.json /root/.composer

WORKDIR /var/www/html

RUN composer create-project --repository-url=https://repo.magento.com/ \
                            --no-interaction \
                            --no-install \
                            magento/project-community-edition:2.4.3 .

RUN composer config --no-plugins allow-plugins.laminas/laminas-dependency-plugin true
RUN composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
RUN composer config --no-plugins allow-plugins.magento/composer-dependency-version-audit-plugin true
RUN composer config --no-plugins allow-plugins.magento/composer-root-update-plugin true
RUN composer config --no-plugins allow-plugins.magento/inventory-composer-installer true
RUN composer config --no-plugins allow-plugins.magento/magento-composer-installer true

RUN composer install

RUN chown -R www-data:www-data /var/www/html
