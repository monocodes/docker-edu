*************************************************
117. Creating a Laravel App via the Composer Utility Container
*************************************************

docker compose run --rm composer create-pro
ject --prefer-dist laravel/laravel .





*************************************************
118. Fixing Errors With The Next Lecture
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