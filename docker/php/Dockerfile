FROM ubuntu:20.04
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
RUN apt install -y build-essential sudo git php php-fpm php-pear php-dev libmcrypt-dev
RUN apt remove -y apache2
RUN pecl channel-update pecl.php.net
RUN pecl install mcrypt
RUN echo "extension=mcrypt.so" >> /etc/php/7.4/fpm/php.ini
RUN echo "extension=mcrypt.so" >> /etc/php/7.4/cli/php.ini
RUN apt install -y php7.4-bcmath php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-mysql \
                   php7.4-soap php7.4-redis php7.4-xdebug php7.4-zip
RUN apt-get clean

RUN rm /var/www/html/index.html

COPY fpm/magento2-pool.conf /etc/php/7.4/fpm/pool.d

COPY bin/composer-install.sh /root
RUN chmod +x /root/composer-install.sh
WORKDIR /root
RUN ./composer-install.sh
RUN mv /root/composer.phar /usr/local/bin/composer

VOLUME /root/.config/composer
VOLUME /root/.cache/composer
VOLUME /var/www/html

COPY composer/auth.json /root/.config/composer

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

CMD ["php-fpm7.4", "-F"]
