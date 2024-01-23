FROM php:8.3.1-fpm-bookworm as php-fpm

RUN apt-get update && apt-get install -y \        
	libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libicu-dev \
        libpq-dev \
        libxpm-dev \
        libvpx-dev \
	libzip-dev \
	libonig-dev \
	postgresql-server-dev-all \
    && pecl install xdebug \
    && pecl install redis \
    && docker-php-ext-enable xdebug \  
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) pgsql \
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && docker-php-ext-install -j$(nproc) xml \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) soap \
    && docker-php-ext-install -j$(nproc) exif \
    && docker-php-ext-enable redis \
    && usermod -s /bin/bash www-data	

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer	
		
FROM golang:1.21-bookworm AS builder

ADD ./docker/php/supervisord/ /src

WORKDIR /src

RUN GOOS=linux go build -tags release -a -ldflags "-linkmode external -extldflags -static" -o /usr/local/bin/supervisord 

FROM php-fpm

COPY --from=builder /usr/local/bin/supervisord /usr/local/bin/supervisord
COPY ./docker/php/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c","/entrypoint.sh"]
