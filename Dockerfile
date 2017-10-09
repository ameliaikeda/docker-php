FROM composer:latest as composer
FROM alpine:latest

LABEL maintainer="amelia@dorks.io"

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_NO_INTERACTION 1
ENV COMPOSER_HOME /usr/lib/composer
ENV COMPOSER_CACHE_DIR /var/cache/composer

RUN apk --update add \
    ca-certificates \
    php7 \
    php7-cli \
    php7-curl \
    php7-gd \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-opcache \
    php7-openssl \
    php7-pdo_pgsql \
    php7-zip \
    php7-phar \
    php7-tokenizer \
    php7-fileinfo \
    php7-pcntl \
    php7-posix \
    php7-zlib \
    php7-iconv \
    php7-session \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

COPY php.ini /etc/php7/conf.d/20-extra.ini
COPY --from=composer /usr/bin/composer /usr/bin

RUN composer global require hirak/prestissimo && rm -rf /var/cache/composer/*

CMD ["php", "-a"]
