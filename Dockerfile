FROM php:7.2-apache
RUN apt-get update -yqq \
    && apt-get install git -yqq \
    && apt-get install wget -yqq \
    && apt-get install zip -yqq \
    && apt-get install unzip -yqq
RUN apt-get update && apt-get install -y \
	libfreetype6-dev \
	libpng-dev \
	libjpeg62-turbo-dev \
	libtidy-dev \
	libcurl4-gnutls-dev \
	libcurl4 \
	libxml2 \
	libxml2-dev \
	&& docker-php-ext-install -j$(nproc) iconv \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install -j$(nproc) tidy \
	&& docker-php-ext-install -j$(nproc) mysqli \
	&& docker-php-ext-install -j$(nproc) pdo \
	&& docker-php-ext-install -j$(nproc) pdo_mysql \
	&& docker-php-ext-install -j$(nproc) curl \
	&& docker-php-ext-install -j$(nproc) mbstring \
	&& docker-php-ext-install -j$(nproc) zip \
	&& docker-php-ext-install -j$(nproc) xml \
	&& pecl install xdebug-2.6.0 \
	&& docker-php-ext-enable xdebug gd mysqli pdo pdo_mysql tidy curl mbstring zip xml \
	&& a2enmod rewrite \
	&& echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini
RUN wget https://composer.github.io/installer.sig -O - -q | tr -d '\n' > installer.sig \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === file_get_contents('installer.sig')) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php'); unlink('installer.sig');" \
    && mv composer.phar /usr/local/bin/composer
RUN wget -c https://releases.taotesting.com/TAO_3.3.0-RC2_build.zip \
	&& unzip TAO_3.3.0-RC2_build.zip \
	&& mv TAO_3.3.0-RC2_build/* /var/www/html/ \
	&& mv TAO_3.3.0-RC2_build/.htaccess /var/www/html/ \
	&& rm -rf TAO_3.3.0-RC2_build* \
	&& chown www-data: -R /var/www/html
