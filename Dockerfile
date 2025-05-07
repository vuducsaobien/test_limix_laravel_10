FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/laravel_10_study

# Copy existing application directory
COPY . .

# Install dependencies
RUN composer install

# Create storage directory structure
RUN mkdir -p /var/www/laravel_10_study/storage/logs \
    && mkdir -p /var/www/laravel_10_study/storage/framework/sessions \
    && mkdir -p /var/www/laravel_10_study/storage/framework/views \
    && mkdir -p /var/www/laravel_10_study/storage/framework/cache \
    && mkdir -p /var/www/laravel_10_study/bootstrap/cache

# Set permissions
RUN chown -R www-data:www-data /var/www/laravel_10_study \
    && chmod -R 777 /var/www/laravel_10_study/storage \
    && chmod -R 777 /var/www/laravel_10_study/bootstrap/cache

# Expose port 9000
EXPOSE 9000

CMD ["php-fpm"]
