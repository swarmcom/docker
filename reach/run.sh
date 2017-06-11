#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
MONGODB=${MONGODB:-"mongodb.$NETWORK"}
ELASTIC=${ELASTIC:-"elastic.$NETWORK"}
SIPXCOM=${SIPXCOM:-"sipxcom.$NETWORK"}
HOSTNAME=${HOSTNAME:-"reach.$NETWORK"}
FSNODE=${FSNODE:-"freeswitch@freeswitch.$NETWORK"}
NODE=${NODE:-"reach@$HOSTNAME"}

if [ -n "$(docker ps -aq -f name=$HOSTNAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $HOSTNAME
	echo -n "removing: "
	docker rm -f $HOSTNAME
fi

echo -n "starting: $HOSTNAME "
docker run $FLAGS \
	--net $NETWORK \
	-h $HOSTNAME \
	--name $HOSTNAME \
	--env NETWORK=$NETWORK \
	--env MONGODB=$MONGODB \
	--env ELASTIC=$ELASTIC \
	--env SIPXCOM=$SIPXCOM \
	--env NODE=$NODE \
	--env FSNODE=$FSNODE \
	$NETWORK/reach
