#!/bin/sh -e
FLAGS=${1:-"-td"}
IMAGE=${2:-"ezuce/agents"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"agents.$NETWORK"}
NODE=${NODE:-"agents@$NAME"}
BUSYTONE_NODE=${BUSYTONE_NODE:-"busytone@busytone.$NETWORK"}
REACH_KAMAILIO=${REACH_KAMAILIO:-"kamailio.$NETWORK"}

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
	--env NODE=$NODE \
	--env BUSYTONE_NODE=$BUSYTONE_NODE \
	--env REACH_KAMAILIO=$REACH_KAMAILIO \
	$IMAGE
