FROM richarvey/nginx-php-fpm:latest

ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

COPY . /var/www/html
WORKDIR /var/www/html

RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
