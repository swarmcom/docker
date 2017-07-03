#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"sipxconfig.$NETWORK"}

docker run $FLAGS \
 --name sipxconfig \
 --link mongo:mongodb.ezuce \
 --link postgres:postgres.ezuce \
 -v `pwd`/run/conf:/usr/local/sipx/etc/sipxpbx/conf \
 -h $NAME \
 -p 12000:12000 \
 $NETWORK/sipxconfig
