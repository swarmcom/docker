#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
REACH_NODE=${REACH_NODE:-"reach@reach.$NETWORK"}
NAME=${NAME:-"kamailio.$NETWORK"}
SIP_DOMAIN=${SIP_DOMAIN:-$NAME}
EXT_IP=${EXT_IP:-"$(curl -s ifconfig.co)"}

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
	-p 5060:5060/udp \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env REACH_NODE=$REACH_NODE \
	--env NAME=$NAME \
	--env SIP_DOMAIN=$SIP_DOMAIN \
	--env EXT_IP=$EXT_IP \
	$NETWORK/kamailio
