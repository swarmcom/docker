#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"named.$NETWORK"}

docker run $FLAGS \
      --name named \
      -h $NAME \
      -p 53:53/udp \
      -v `pwd`/srv/docker/bind9:/named \
      $NETWORK/bind9
