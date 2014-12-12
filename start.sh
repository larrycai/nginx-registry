#!/bin/bash

NGINX=/usr/local/nginx
DATA=/data

cp /app/nginx/nginx.conf ${NGINX}/conf/nginx.conf
cp /app/nginx/docker-registry.default ${NGINX}/conf/docker-registry.default

if [ -d ${DATA} ];
then
    echo "use default for demo purpose !!"
else
	mkdir -p ${DATA}
	mkdir -p /conf
	cp /app/nginx/server.crt ${DATA}/
	cp /app/nginx/server.key ${DATA}/
	cp /app/nginx/docker-registry.htpasswd ${DATA}/
fi

${NGINX}/sbin/nginx
