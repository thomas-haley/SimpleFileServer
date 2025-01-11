FROM php:7-alpine
COPY ./:/var/www
RUN composer update