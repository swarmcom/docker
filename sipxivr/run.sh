#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"sipxivr.$NETWORK"}

docker run $FLAGS \
 --name sipxivr \
 --link mongo:mongodb.ezuce \
 -h $NAME \
 $NETWORK/sipxivr
