FROM php:7.3.6-fpm-alpine3.9 AS base
RUN apk update && \
    apk upgrade && \
    apk add --update libzip-dev curl-dev
RUN docker-php-ext-install pdo_mysql mbstring curl

FROM base AS composer
RUN apk add git \
        libzip-dev zip unzip && \
        docker-php-ext-configure zip --with-libzip && \
        docker-php-ext-install zip && \
        php -m | grep -q 'zip'
RUN curl --silent --fail --location --retry 3 --output /tmp/installer.php \
    --url https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer \
    && php -r " \
        \$signature = '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5'; \
        \$hash = hash('sha384', file_get_contents('/tmp/installer.php')); \
        if (! hash_equals(\$signature, \$hash)) { \
            unlink('/tmp/installer.php'); \
            echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
            exit(1); \
        }" \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=1.8.5 \
    && composer --ansi --version --no-interaction \
    && rm -f /tmp/installer.php

FROM composer as deps
COPY composer.json composer.lock /var/www/site-app/
COPY database /var/www/site-app/database
COPY tests /var/www/site-app/tests
WORKDIR /var/www/site-app
RUN composer install --no-dev

FROM base AS build
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY . /var/www/site-app
COPY --from=deps /var/www/site-app/vendor /var/www/site-app/vendor
WORKDIR /var/www/site-app
RUN rm -rf public
COPY public/.htaccess public/index.php /var/www/site-app/public/
