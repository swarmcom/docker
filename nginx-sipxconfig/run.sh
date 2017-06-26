#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"nginx.$NETWORK"}

docker run $FLAGS \
	--name nginx \
  -h $NAME \
	--link sipxconfig:sipxconfig.ezuce \
  -p 80:80 \
	-v `pwd`/etc/sipxconfig.conf:/etc/nginx/conf.d/default.conf \
  nginx
