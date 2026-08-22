FROM php:8.1-cli

# Install dependencies dan modul database MySQL
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring bcmath

# Pasang Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . /var/www/html

# Install dependensi Laravel
RUN composer install --no-dev --optimize-autoloader

# Atur permissions direktori storage & cache
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

# Jalankan server bawaan Laravel pada port dinamis Railway
CMD sh -c "php -S 0.0.0.0:${PORT:-80} -t public"
