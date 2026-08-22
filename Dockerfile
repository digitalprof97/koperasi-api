FROM php:8.1-cli

# Install dependensi dan ekstensi database PDO MySQL
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

# Install vendor dependencies
RUN composer install --no-dev --optimize-autoloader

# Atur permissions Laravel
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port
EXPOSE 8080

# Jalankan artisan serve langsung mengikat ke 0.0.0.0 dan port 8080
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
