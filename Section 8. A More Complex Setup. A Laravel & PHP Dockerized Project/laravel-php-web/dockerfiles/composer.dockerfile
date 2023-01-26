FROM composer:latest

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
# --ignore-platform-reqs ensures that we can run
#this without any warnings or errors even if some
#dependencies would be missing