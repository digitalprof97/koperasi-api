FROM richarvey/nginx-php-fpm:latest

ENV RUN_SCRIPTS 0
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV REAL_IP_HEADER 1
ENV COMPOSER_ALLOW_SUPERUSER 1

# Pasang konfigurasi virtual host Nginx untuk URL rewriting Laravel
RUN echo 'server {' \
    '    listen 80 default_server;' \
    '    listen [::]:80 default_server;' \
    '    root /var/www/html/public;' \
    '    index index.php index.html;' \
    '    location / {' \
    '        try_files $uri $uri/ /index.php?$query_string;' \
    '    }' \
    '    location ~ \.php$ {' \
    '        fastcgi_pass unix:/var/run/php-fpm.sock;' \
    '        fastcgi_index index.php;' \
    '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' \
    '        include fastcgi_params;' \
    '    }' \
    '}' > /etc/nginx/sites-available/default.conf

# Ekstensi database MySQL
RUN docker-php-ext-install pdo_mysql mbstring bcmath

COPY . /var/www/html
WORKDIR /var/www/html

RUN composer install --no-dev --optimize-autoloader --no-plugins --no-scripts
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
