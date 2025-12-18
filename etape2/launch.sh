#!/bin/bash

sudo docker container stop http script data 2>/dev/null
sudo docker container rm http script data 2>/dev/null
sudo docker network rm tp3-net 2>/dev/null

sudo docker network create tp3-net

sudo docker build -t php-mysqli ./php

sudo docker run -d \
 --name data \
 --network tp3-net \
 -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
 -e MARIADB_DATABASE=tp3 \
 -e MARIADB_USER=tp3 \
 -e MARIADB_PASSWORD=tp3 \
 -v $(pwd)/sql:/docker-entrypoint-initdb.d \
 mariadb

sudo docker run -d \
 --name script \
 --network tp3-net \
 -v $(pwd)/src:/app \
 php-mysqli

sudo docker run -d \
 --name http \
 --network tp3-net \
 -p 8080:8080 \
 -v $(pwd)/src:/app \
 -v $(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf \
 nginx:alpine
