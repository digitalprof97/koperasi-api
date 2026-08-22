FROM richarvey/nginx-php-fpm:latest

ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Pasang konfigurasi Nginx untuk rewrite routing Laravel
RUN printf '%s\n' \
    'server {' \
    '    listen 80 default_server;' \
    '    listen [::]:80 default_server;' \
    '    root /var/www/html/public;' \
    '    index index.php index.html index.htm;' \
    '    location / {' \
    '        try_files $uri $uri/ /index.php?$query_string;' \
    '    }' \
    '    location ~ \.php$ {' \
    '        try_files $uri =404;' \
    '        fastcgi_split_path_info ^(.+\.php)(/.+)$;' \
    '        fastcgi_pass unix:/var/run/php-fpm.sock;' \
    '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' \
    '        fastcgi_param SCRIPT_NAME $fastcgi_script_name;' \
    '        fastcgi_index index.php;' \
    '        include fastcgi_params;' \
    '    }' \
    '}' > /etc/nginx/sites-available/default.conf

COPY . /var/www/html
WORKDIR /var/www/html

RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
