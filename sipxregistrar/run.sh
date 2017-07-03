#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"sipxregistrar.$NETWORK"}

docker run $FLAGS \
 --name sipxregistrar \
 --link mongo:mongodb.ezuce \
 --link postgres:postgres.ezuce \
 --link sipxconfig:sipxconfig.ezuce \
 -h $NAME \
 -p 5070:5070 \
 -p 5075:5075 \
 -p 5077:5077 \
 -v /home/mcostache/PROIECTELE_MELE/ezuce/docker/sipxregistrar/conf/registrar-config:/usr/local/sipx/etc/sipxpbx/registrar-config \
 $NETWORK/sipxregistrar
