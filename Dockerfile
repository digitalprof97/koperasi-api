FROM php:8.1-cli

# Install dependensi sistem dan ekstensi database
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

# Install dependency vendor
RUN composer install --no-dev --optimize-autoloader

# Atur permission storage dan bootstrap cache
RUN chmod -R 777 storage bootstrap/cache

# Jalankan server Laravel artisan langsung mengikat host 0.0.0.0 dan port dinamis Railway
CMD sh -c "php artisan serve --host=0.0.0.0 --port=${PORT:-8080}"
