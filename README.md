# docker-php

A PHP image for docker that works with Laravel. Includes modules needed for running Laravel/Symfony, and has an FPM version that bundles nginx with a decent configuration.

By default, this will always track the latest version of PHP. To lock to a specific version, use `amelia/php:7.1-cli` and `amelia/php:7.1-fpm`, and so on. **[TODO 2017-10-20]**

# Composer

All images include the latest version of composer, globally installed, with [prestissimo][prestissimo] installed for parallel composer downloads to speed up your builds (use `--prefer-dist` for this). The image also configures composer for no-interaction mode.

To use a github oauth token, just set a `GITHUB_TOKEN` environment variable using whichever method you like.

To clean up composer and clean your builds properly after running `composer install`, run `rm -rf /var/cache/composer/*` at the end of your `RUN` command to avoid bloating your layers with caches from Packagist.

# Usage

Use `amelia/php:cli` for a tiny cli image of the latest version of PHP, or use `amelia/php:fpm` to use an FPM image with nginx and supervisor bundled.

Most extensions are included, so you can usually use this image as-is, and this image is based off of [Alpine Linux][alpine] and weighs in at about 25MB cli and 45MB fpm (compressed).

The modules included in both CLI and FPM images are:

- curl
- gd
- intl
- json
- mbstring
- opcache
- openssl
- pdo_pgsql
- pdo_mysql
- pdo_sqlite
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

The assumed work directory for this image is `/srv/code`. This is where all commands are relative to, and where you should mount or `COPY` your code. The FPM image assumes the webroot is `/srv/code/public` and the index file is `index.php`.

# CLI Usage

To use the CLI image you can literally just run `docker run -it amelia/php:cli` to drop yourself into a PHP shell, or you can mount files and run them.

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
- If you don't want to pull more than one image, you can just use the `fpm` image as a CLI one; it's fully functional.
- This project is set to auto-build a new version on every alpine, php, nginx or composer docker image update.

# Security

If there are any security issues with this image, you can poke me on twitter [@ameliaikeda][twitter].

[supervisor]: http://supervisord.org/
[alpine]: https://alpinelinux.org/ 
[letsencrypt]: https://letsencrypt.org/
[licence]: https://github.com/ameliaikeda/docker-php/blob/master/LICENSE
[twitter]: https://twitter.com/ameliaikeda
[dhparam]: https://hub.docker.com/r/amelia/dhparam/
[prestissimo]: https://github.com/hirak/prestissimo
