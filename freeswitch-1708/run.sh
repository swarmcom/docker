#!/bin/sh -e
FLAGS=${1:-"-td"}
IMAGE=${2:-"ezuce/freeswitch-1708"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"freeswitch.$NETWORK"}
REACHME_NODE=${REACHME_NODE:-"reach@reach.$NETWORK"}
AGENTS_GW=${AGENTS_GW:-"agents.ezuce"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
   echo -n "stopping: "
   docker stop -t 1 $NAME
   echo -n "removing: "
   docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker run $FLAGS \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NODE=freeswitch@$NAME \
	--env REACHME_NODE=$REACHME_NODE \
	--env AGENTS_GW=$AGENTS_GW \
	$IMAGE
