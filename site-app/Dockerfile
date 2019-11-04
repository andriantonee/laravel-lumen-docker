FROM php:7.3.6-fpm-alpine3.9 AS base
RUN apk update && \
    apk upgrade
RUN apk add --no-cache \
    libzip-dev && \
    # php extension
    docker-php-ext-install pdo_mysql mbstring && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install zip
RUN curl --silent --fail --location --retry 3 \
    --output /tmp/installer.php \
    --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer && \
    php -r " \
        \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
        \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
        if (! hash_equals(\$signature, \$hash)) { \
            unlink('/tmp/installer.php'); \
            echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
            exit(1); \
        }" && \
    php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=1.8.5 && \
    composer --ansi --version --no-interaction && \
    rm -rf /tmp/*
COPY php_config/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN cp $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

FROM base AS build
WORKDIR /var/www/site-app
COPY composer.json /var/www/site-app/composer.json
COPY composer.lock /var/www/site-app/composer.lock
RUN composer install --no-dev --no-autoloader --no-scripts && \
    rm -rf /root/.composer
COPY --chown=www-data . /var/www/site-app
RUN rm -rf public
COPY --chown=www-data public/.htaccess public/index.php /var/www/site-app/public/
RUN composer dump-autoload --optimize && \
    rm -rf /usr/bin/composer
RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
