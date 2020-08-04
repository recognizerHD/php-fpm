FROM php:7.4.8-fpm-alpine3.12
LABEL maintainer="Paul Warren"

# Install dependencies
RUN apk update && apk add --no-cache \
    tidyhtml-dev \
    bzip2-dev \
    libxslt-dev \
    libzip-dev \
    libpng-dev libjpeg-turbo-dev freetype-dev jpegoptim optipng pngquant gifsicle \
    vim \
    mariadb-client \
    zip \
    unzip \
    git \
    supervisor \
    curl \
    && mkdir /etc/supervisor.d \
    && mkdir /etc/cron.d/

COPY ./supervisord.conf /etc/supervisord.conf
COPY ./cron-jobs /etc/cron.d/cron-jobs
COPY ./php-fpm.ini /etc/supervisor.d/
#COPY ./cron.ini /etc/supervisor.d/
COPY ./laravel-worker.ini /etc/supervisor.d/

# Install extensions
# xml already loaded
RUN docker-php-ext-install bz2 exif pdo_mysql pcntl sockets tidy xsl zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && apk del .phpize-deps \
    && docker-php-ext-enable redis \
    && chmod 0755 /etc/cron.d/cron-jobs \
    && crontab /etc/cron.d/cron-jobs \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# https://stackoverflow.com/questions/37458287/how-to-run-a-cron-job-inside-a-docker-container
# Clear cache
# RUN apk del tidyhtml-dev bzip2-dev libxslt-dev libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Expose port 9000 and start php-fpm server
# EXPOSE 9000
# Already exposed from
# CMD ["php-fpm"]
#
#ENTRYPOINT ["crond", "-d"]

COPY recognizer-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/recognizer-entrypoint.sh / # backwards compat
WORKDIR /var/www
ENTRYPOINT ["recognizer-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]