#!/bin/bash

sudo docker container stop http script 2>/dev/null
sudo docker container rm http script 2>/dev/null

sudo docker container run -d \
 --name script \
 --network tp3-net \
 -v $(pwd)/src:/app \
 php:8.2-fpm

sudo docker container run -d \
 --name http \
 --network tp3-net \
 -p 8080:8080 \
 -v $(pwd)/src:/app \
 -v $(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf \
 nginx:alpine
