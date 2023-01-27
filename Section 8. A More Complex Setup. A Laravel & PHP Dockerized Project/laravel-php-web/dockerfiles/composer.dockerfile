FROM composer:latest

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel 

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
# --ignore-platform-reqs ensures that we can run
#this without any warnings or errors even if some
#dependencies would be missing