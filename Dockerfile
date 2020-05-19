FROM php:7.4.5-fpm-alpine3.11
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
    curl

# Install extensions
RUN docker-php-ext-install bz2 exif pdo_mysql pcntl tidy xml zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Clear cache
# RUN apk del tidyhtml-dev bzip2-dev libxslt-dev libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev

# Expose port 9000 and start php-fpm server
# EXPOSE 9000
# Already exposed from
CMD ["php-fpm"]
