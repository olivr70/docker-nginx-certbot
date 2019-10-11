#!/bin/bash
VERSION=0.0.1

NGINX_USER=${NGINX_USER:-nginx}
NGINX_UID=$(id -u "$NGINX_USER")

echo "Construction nginx-certbot avec l'utilisateur $NGINX_USER ($NGINX_UID)"
docker build --build-arg UID=$NGINX_UID -t "olivr70/nginx-certbot:$VERSION" .
