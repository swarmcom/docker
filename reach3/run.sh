#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"reach.$NETWORK"}
FSNODE=${FSNODE:-"freeswitch@freeswitch.$NETWORK"}
KAMNODE=${KAMNODE:-"kamailio@kamailio.$NETWORK"}
NODE=${NODE:-"reach@$NAME"}

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

echo -n "starting: $NAME "
docker run $FLAGS \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env NODE=$NODE \
	--env FSNODE=$FSNODE \
	--env KAMNODE=$KAMNODE \
	$NETWORK/reach
