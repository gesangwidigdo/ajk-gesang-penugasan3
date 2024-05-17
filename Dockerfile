FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    libonig-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    nodejs \
    npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN npm i -g yarn -y

COPY package.json yarn.lock ./

COPY . /var/www/html

WORKDIR /var/www/html

RUN chmod -R 775 . && chown -R www-data:www-data .

# RUN composer install --optimize-autoloader --no-dev

RUN COMPOSER_ALLOW_SUPERUSER=1 composer install

RUN cp .env.example .env 

# RUN yarn install && yarn build

# RUN php artisan key:generate \ 
#     php artisan migrate

EXPOSE 9000

CMD [ "php-fpm" ]