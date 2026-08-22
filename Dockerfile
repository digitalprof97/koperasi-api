FROM richarvey/nginx-php-fpm:latest

# Aktifkan konfigurasi bawaan Laravel
ENV LARAVEL_PROJ 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV REAL_IP_HEADER 1
ENV COMPOSER_ALLOW_SUPERUSER 1

# Pasang ekstensi database MySQL
RUN docker-php-ext-install pdo_mysql mbstring bcmath

COPY . /var/www/html
WORKDIR /var/www/html

# Install package tanpa script bawaan yang usang
RUN composer install --no-dev --optimize-autoloader --no-plugins --no-scripts
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
