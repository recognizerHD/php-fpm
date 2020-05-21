# PHP FPM Image with supervisor daemon

This docker image is based on the alpine docker image.

The notable differences from the base image are:
* Added extensions: bz2 exif gd pdo_mysql pcntl tidy xml zip
* Installed git
* Installed supervisor
* Runs Crond
    * every minute runs laravel: 
    ```
    cd /var/www/ && php artisan schedule:run >> /dev/null 2>&1
    ```
* Runs supervisord that spawns:
    * php-fpm
    * runs laravel: php artisan queue:worker


## How to use this image
This will run a laravel queue:worker. It is intended for Laravel already be installed to /var/www prior to running this docker image.

Please visit [php:fpm-alpine](https://hub.docker.com/_/php) on how to use this image.

# NOTE
