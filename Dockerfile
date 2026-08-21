FROM php:8.1-cli-alpine

# Install ekstensi PHP & dependensi yang dibutuhkan
RUN apk update && apk add --no-cache \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    oniguruma-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Install dependency vendor Laravel
RUN composer install --no-dev --optimize-autoloader

# Atur permission storage Laravel
RUN chmod -R 777 storage bootstrap/cache

EXPOSE 8080

# Jalankan server bawaan Laravel dengan port dinamis Railway
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8080}
