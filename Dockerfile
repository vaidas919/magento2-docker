FROM ubuntu:20.04
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
RUN apt install -y build-essential
RUN apt install -y apt php php-fpm php-pear php-dev libmcrypt-dev
RUN pecl channel-update pecl.php.net
RUN pecl install mcrypt
RUN echo "extension=mcrypt.so" >> /etc/php/7.4/fpm/php.ini
RUN echo "extension=mcrypt.so" >> /etc/php/7.4/cli/php.ini
COPY bin/composer-install.sh /
