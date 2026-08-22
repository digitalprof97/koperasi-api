FROM php:8.1-cli

# Install dependensi sistem dan ekstensi MySQL
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring

# Pasang Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Install dependensi Laravel
RUN composer install --no-dev --optimize-autoloader

# Atur permission folder storage
RUN chmod -R 777 storage bootstrap/cache

EXPOSE 8080

# Jalankan server bawaan PHP langsung mengarah ke file routing public/index.php
CMD php -S 0.0.0.0:${PORT:-8080} -t public public/index.php
