*************************************************
117. Creating a Laravel App via the Composer Utility Container
*************************************************

docker compose run --rm composer create-pro
ject --prefer-dist laravel/laravel .





*************************************************
117. Fixing Errors With The Next Lecture (Linux)
*************************************************You can ignore this lecture if you're not facing errors in the next lecture. However, if you do, take another look at this text lecture here.

---

When using Docker on Linux, you might face permission errors when adding a bind mount as shown in the next lecture. If you do, try these steps:

Change the php.dockerfile so that it looks like that:

FROM php:8.0-fpm-alpine
 
WORKDIR /var/www/html
 
COPY src .
 
RUN docker-php-ext-install pdo pdo_mysql
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel
Please note that the RUN chown instruction was removed here, instead we now create a user "laravel" which we use (with the USER instruction) for commands executed inside of this image / container).

Also edit the composer.dockerfile to look like this:

FROM composer:latest
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel
 
WORKDIR /var/www/html
 
ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
Here, we add that same "laravel" user and use it for creating the project therefore.

These steps should ensure that all files which are created by the Composer container are assigned to a user named "laravel" which exists in all containers which have to work on the files.

Also see this Q&A thread: https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/#questions/12986850/





*************************************************
119. My macOS m1 fixes
*************************************************

# php.dockerfile
FROM php:8.1-fpm-alpine

# command for running composer utility container
# and creating lavarel project
docker-compose run --rm composer create-project --prefer-dist laravel/laravel:^8.0 .

# use platform instruction on mysql image
mysql:
    platform: linux/x86_64
    image: mysql:5.7
    env_file:
      - ./env/mysql.env




*************************************************
119. All fixes for Lavarel Project from Q&A
*************************************************


[READ} Laravel Project -- IF YOU HAVE ISSUES
31 upvotes
Joel · Lecture 119 · 3 months ago
OLD THREAD WITH FIXES WAS GETTING TOO LONG TO GO THROUGH.

1. Grab Max's snapshot from the end of the section, and use the code found in laravel-04-fixed.zip

2. Open the dockerfiles/php.dockerfile, and change the FROM instruction to FROM php:8.1-fpm-alpine , save and close the file

3. To avoid file permissions issue if you have an "src" folder still in your root project folder, delete it and recreate it (so it is an empty folder)

4. Time to create our Laravel project, run docker-compose run --rm composer create-project --prefer-dist laravel/laravel:^8.0 . , in your root project's folder

5. Open src/.env in your editor and change the configuration lines for the database connection as follows

DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret
6. Run the project, docker-compose up mysql server php and access it on http://localhost:8000

---

composer.dockerfile

FROM composer:latest
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel 
 
WORKDIR /var/www/html
 
ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
nginx.dockerfile

FROM nginx:stable-alpine
 
WORKDIR /etc/nginx/conf.d
 
COPY nginx/nginx.conf .
 
RUN mv nginx.conf default.conf
 
WORKDIR /var/www/html
 
COPY src .
php.dockerfile

FROM php:8.1-fpm-alpine
 
WORKDIR /var/www/html
 
COPY src .
 
RUN docker-php-ext-install pdo pdo_mysql
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel
docker-compose.yml

version: '3.8'
 
services:
    server:
        # image: 'nginx:stable-alpine'
        build:
            context: .
            dockerfile: dockerfiles/nginx.dockerfile
        ports:
            - '8000:80'
        volumes:
            - ./src:/var/www/html
            - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
        depends_on:
            - php
            - mysql
    php:
        build:
            context: .
            dockerfile: dockerfiles/php.dockerfile
        volumes:
            - ./src:/var/www/html:delegated
    mysql:
        image: mysql:5.7
        env_file:
            - ./env/mysql.env
    composer:
        build:
            context: ./dockerfiles
            dockerfile: composer.dockerfile
        volumes:
            - ./src:/var/www/html
    artisan:
        build:
            context: .
            dockerfile: dockerfiles/php.dockerfile
        volumes:
            - ./src:/var/www/html
        entrypoint: ['php', '/var/www/html/artisan']
    npm:
        image: node:14
        working_dir: /var/www/html
        entrypoint: ['npm']
        volumes:
            - ./src:/var/www/html





*************************************************
119. Launching Only Some Docker Compose Services
*************************************************

# run the containers and rebuild the images if
# something changed in Dockerfiles 
docker compose up -d --build server




*************************************************
120. Adding More Utility Containers
*************************************************

# run and check the artisan container
docker compose run --rm artisan migrate




*************************************************
120. Fixing the initial setup based on videos
*************************************************

Actually the whole setup on macOS m1 could be based on videos and needs just these fixes:

# php.dockerfile
FROM php:8.1-fpm-alpine

# command for running composer utility container
# and creating lavarel project
docker-compose run --rm composer create-project --prefer-dist laravel/laravel:^8.0 .

# use platform instruction on mysql image
mysql:
    platform: linux/x86_64
    image: mysql:5.7
    env_file:
      - ./env/mysql.env

# don't forget to update the db creds in 
# ./scr/.env and also update DB_HOST=127.0.0.1
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret

DB_HOST=mysql