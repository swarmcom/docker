#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"sipxregistrar.$NETWORK"}

docker run $FLAGS \
 --name sipxregistrar \
 --link mongo:mongodb.ezuce \
 --link postgres:postgres.ezuce \
 --link sipxconfig:sipxconfig.ezuce
 -h $NAME \
 -p 5070:5070 \
 $NETWORK/sipxregistrar
