# docker-php

A PHP image for docker that works with Laravel. Includes modules needed for running Laravel/Symfony, and has an FPM version that bundles nginx with a decent configuration.

By default, this will always track the latest version of PHP. To lock to a specific version, use `amelia/php:7.1` or `amelia/php:7.2`, etc.

# Composer

The latest version of composer, is globally installed, with [prestissimo][prestissimo] installed for parallel composer downloads to speed up your builds (use `--prefer-dist` for this). The image also configures composer for no-interaction mode.

To use a github oauth token, just set a `GITHUB_TOKEN` environment variable using whichever method you like.

To clean up composer and clean your builds properly after running `composer install`, run `rm -rf /var/cache/composer/*` at the end of your `RUN` command to avoid bloating your layers with caches from Packagist.

# Usage

This image comes with nginx and supervisor bundled, as well as a `php` cli process and php-fpm.

Most extensions are included, so you can usually use this image as-is, and this image is based off of [Alpine Linux][alpine] and weighs in at about 45MB (compressed).

The modules included are:

- curl
- gd
- intl
- json
- mbstring
- opcache
- openssl
- pdo_pgsql
- pdo_mysql
- zip
- phar
- tokenizer
- fileinfo
- pcntl
- posix
- zlib
- iconv
- session
- sockets
- dom
- xml
- xmlwriter
- xmlreader
- simplexml
- ctype

The assumed work directory for this image is `/srv/code`. This is where all commands are relative to, and where you should mount or `COPY` your code. The fpm/nginx processes assume the webroot is `/srv/code/public` and the index file is `index.php`.

# CLI Usage

To use this as a CLI image you can literally just run `docker run -it` and run a php command.

# FPM Usage

By default we run a secure nginx setup with a snakeoil (self-signed) certificate, PHP-FPM, and a [supervisord][supervisor] process to manage everything.

**Before using this image in production exposing 443, you'll want to add a proper certificate.**

You can get a certificate from [Let's Encrypt][letsencrypt] for free or factor this into your deployment or server orchestration.

Certificates can be baked into your own private image, or you can mount them to:

- certificate: `/etc/nginx/certs/certificate.pem`
- private key: `/etc/nginx/certs/privkey.pem`
- trusted chain: `/etc/nginx/certs/chain.pem`

You can mount your code to `/srv/code`. `/srv/code/public` is assumed to be the webroot.

There is already a generated `dhparam.pem` located at `/etc/nginx/dhparam.pem` generated from [amelia/dhparam][dhparam], but you can feel free to replace that if you wish.

# Extra Configuration

PHP config is at `/etc/php7/{conf.d/,php.ini}` for fpm/cli, and `/etc/php7/php-fpm.conf` + `/etc/php7/php-fpm.d/www.conf` for fpm-specific config. You can change these as you wish.

Supervisor config is at `/etc/supervisord.conf` and will monitor both nginx and php-fpm in the fpm image.

# Footnotes

- This image is provided under the BSD Licence, which you can find in the [LICENCE][licence] file.
- As with all prebuilt images, this contains other software under different licences.

# Security

If there are any security issues with this image, you can poke me on twitter [@ameliaikeda][twitter].

[supervisor]: http://supervisord.org/
[alpine]: https://alpinelinux.org/ 
[letsencrypt]: https://letsencrypt.org/
[licence]: https://github.com/ameliaikeda/docker-php/blob/master/LICENSE
[twitter]: https://twitter.com/ameliaikeda
[dhparam]: https://hub.docker.com/r/amelia/dhparam/
[prestissimo]: https://github.com/hirak/prestissimo
