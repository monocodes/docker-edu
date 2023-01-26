*************************************************
# 106. Utilizing ENTRYPOINT
*************************************************
# run utility container with host dir bind mount
# and ENTRYPOINT to execute only commands with
# npm because of ENTRYPOINT [ "npm" ] in
# Dockerfile
docker run -it --rm -v "$(pwd):/app" wanderingmono/docker-s7:util-nodejs-v0.2-entry install express --save





*************************************************
#  107. Using Docker Compose
*************************************************
docker compose run --rm npm install