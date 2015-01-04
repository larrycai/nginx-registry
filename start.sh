#!/bin/bash

NGINX=/usr/local/nginx
DATA=/data

cp /app/nginx/nginx.conf ${NGINX}/conf/nginx.conf
cp /app/nginx/docker-registry.default ${NGINX}/conf/docker-registry.default

if [ ! -f ${DATA}/server.crt ];
then
    echo "use default server certification for demo purpose !!"
	mkdir -p ${DATA}
	mkdir -p /conf
	cp /app/nginx/server.crt ${DATA}/
	cp /app/nginx/server.key ${DATA}/
	cp /app/nginx/docker-registry.htpasswd ${NGINX}/conf
fi

if [ ! -f ${DATA}/docker-registry.htpasswd ];
then
    echo "use default htpasswd for demo purpose !!"
    cp /app/nginx/docker-registry.htpasswd ${DATA}
fi

${NGINX}/sbin/nginx
