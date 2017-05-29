#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"sipxcom.$NETWORK"}

if [ -n "$SIPX_SOURCE" ]
then
   [ ! -e "$SIPX_SOURCE" ] && echo "Sipx source tree set to $SIPX_SOURCE, but not accessible" && exit 1
   SIPX_SOURCE_VOLUME="-v $SIPX_SOURCE:/home/user/sipxecs"
fi

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker run $FLAGS $SIPX_SOURCE_VOLUME \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env SIPX_SOURCE=$SIPX_SOURCE \
	$NETWORK/sipxcom
