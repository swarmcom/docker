#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
AGENTS_NODE=${AGENTS_NODE:-"agents@agents.$NETWORK"}
HOSTNAME=${HOSTNAME:-"busytone.$NETWORK"}
REACH_HOST=${REACH_HOST:-"reach.$NETWORK"}
NODE=${NODE:-"busytone@$HOSTNAME"}

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
	--env NODE=$NODE \
	--env AGENTS_NODE=$AGENTS_NODE \
	--env REACH_HOST=$REACH_HOST \
	$NETWORK/busytone
