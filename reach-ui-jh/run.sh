#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"reach-ui-jh.$NETWORK"}
REACH_WS=${REACH_WS:-""}
REACH_WS=${REACH_HTTP:-""}

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
	--env REACH_WS=$REACH_WS \
	--env REACH_HTTP=$REACH_HTTP \
	$NETWORK/reach-ui-jh
