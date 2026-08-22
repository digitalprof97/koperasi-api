FROM richarvey/nginx-php-fpm:latest

# Matikan script otomatis prestissimo/composer bawaan image yang error
ENV RUN_SCRIPTS 0
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV REAL_IP_HEADER 1
ENV COMPOSER_ALLOW_SUPERUSER 1

# Pasang ekstensi database MySQL
RUN docker-php-ext-install pdo_mysql mbstring bcmath

COPY . /var/www/html
WORKDIR /var/www/html

# Install composer dependency project kita sendiri
RUN composer install --no-dev --optimize-autoloader --no-plugins --no-scripts
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
