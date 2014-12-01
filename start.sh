#!/bin/bash

NGINX=/usr/local/nginx
DATA=/app

cp ${DATA}/nginx/server.crt /etc/ssl/certs/docker-registry
cp ${DATA}/nginx/server.key /etc/ssl/private/docker-registry
cp ${DATA}/nginx/nginx.conf ${NGINX}/conf/nginx.conf
cp ${DATA}/nginx/docker-registry.htpasswd ${NGINX}/conf/docker-registry.htpasswd
cp ${DATA}/nginx/docker-registry.default ${NGINX}/conf/docker-registry.default

${NGINX}/sbin/nginx
