FROM richarvey/nginx-php-fpm:latest

# Konfigurasi Nginx & Laravel
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Konfigurasi routing Nginx agar URL diteruskan ke index.php Laravel
ENV NGINX_SITES_AVAILABLE /etc/nginx/sites-available/default.conf
ENV NGINX_SITES_ENABLED /etc/nginx/sites-enabled/default.conf

COPY . /var/www/html
WORKDIR /var/www/html

# Buat config Nginx untuk Laravel
RUN printf '%s\n' \
    'server {' \
    '    listen 80;' \
    '    root /var/www/html/public;' \
    '    index index.php index.html;' \
    '    charset utf-8;' \
    '    location / {' \
    '        try_files $uri $uri/ /index.php?$query_string;' \
    '    }' \
    '    location ~ \.php$ {' \
    '        fastcgi_pass unix:/var/run/php-fpm.sock;' \
    '        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;' \
    '        include fastcgi_params;' \
    '    }' \
    '}' > /etc/nginx/sites-available/default.conf

RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
