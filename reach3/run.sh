#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
MONGODB=${MONGODB:-"mongodb.$NETWORK"}
ELASTIC=${ELASTIC:-"elastic.$NETWORK"}
SIPXCOM=${SIPXCOM:-"sipxcom.$NETWORK"}
NAME=${NAME:-"reach.$NETWORK"}
FSNODE=${FSNODE:-"freeswitch@freeswitch.$NETWORK"}
NODE=${NODE:-"reach@$NAME"}

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
	--env NETWORK=$NETWORK \
	--env MONGODB=$MONGODB \
	--env ELASTIC=$ELASTIC \
	--env SIPXCOM=$SIPXCOM \
	--env NODE=$NODE \
	--env FSNODE=$FSNODE \
	$NETWORK/reach
