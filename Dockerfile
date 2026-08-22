FROM php:8.1-cli

# Install dependencies dan ekstensi MySQL
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring bcmath

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 777 storage bootstrap/cache

# Jalankan PHP server di port dinamis Railway ($PORT) atau fallback 8080
CMD php -S 0.0.0.0:${PORT:-8080} -t public public/index.php
