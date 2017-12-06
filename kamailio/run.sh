#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
REACH_NODE=${REACH_NODE:-"reach@reach.$NETWORK"}
NAME=${NAME:-"kamailio.$NETWORK"}
NODE=${NODE:-"kamailio@$NAME"}
SIP_DOMAIN=${SIP_DOMAIN:-$NAME}
EXT_IP=${EXT_IP:-"$(curl -s ifconfig.co)"}
PORTMAP=${PORTMAP:-"-p 5060:5060/udp"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

STAMP=`date +%Y-%m-%d-%H-%M-%S`
mkdir -p logs
docker logs $NAME > logs/$STAMP

echo -n "starting: $NAME ext_ip: $EXT_IP "
docker run $FLAGS $PORTMAP \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env REACH_NODE=$REACH_NODE \
	--env NAME=$NAME \
	--env SIP_DOMAIN=$SIP_DOMAIN \
	--env EXT_IP=$EXT_IP \
	--env NODE=$NODE \
	$NETWORK/kamailio
