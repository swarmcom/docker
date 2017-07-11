#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"sipxproxy.$NETWORK"}

docker run $FLAGS \
 --name sipxproxy \
 --link mongo:mongodb.ezuce \
 --link postgres:postgres.ezuce \
 --link sipxconfig:sipxconfig.ezuce \
 -h $NAME \
 -p 5060:5060/udp \
 -p 5061:5061/udp \
 -v  /home/mcostache/PROIECTELE_MELE/ezuce/docker/sipxproxy/conf/sipXproxy-config:/usr/local/sipx/etc/sipxpbx/sipXproxy-config \
 -v /home/mcostache/PROIECTELE_MELE/ezuce/docker/sipxproxy/conf/forwardingrules.xml:/usr/local/sipx/etc/sipxpbx/forwardingrules.xml \
 $NETWORK/sipxproxy
