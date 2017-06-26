#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"sipxproxy.$NETWORK"}

docker run $FLAGS \
 --name sipxproxy \
 --link sipxregistrar:sipxregistrar.ezuce\
 --link mongo:mongodb.ezuce \
 --link postgres:postgres.ezuce \
 --link sipxconfig:sipxconfig.ezuce \
 -h $NAME \
 -p 5060:5060 \
 -p 5061:5061 \
 $NETWORK/sipxproxy
