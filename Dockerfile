# Use the official PHP image as the base image
FROM php:7.4-fpm-alpine

# Set the working directory
WORKDIR /var/www

# Copy the composer.json and composer.lock files to the container
COPY composer.json composer.lock ./

# Install the necessary dependencies
RUN apk add --no-cache --update \
    autoconf \
    g++ \
    make \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install pdo_mysql \
    && apk del --no-cache autoconf g++ make

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install the PHP dependencies
RUN composer install --no-interaction --optimize-autoloader

# Copy the rest of the application files to the container
COPY . ./

# Set the permissions for the Laravel application
RUN chown -R www-data:www-data /var/www

# Run the Laravel application as the www-data user
USER www-data

# Expose port 9000 for PHP-FPM
EXPOSE 9000
