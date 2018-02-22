#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
AGENTS_NODE=${AGENTS_NODE:-"agents@agents.$NETWORK"}
NAME=${NAME:-"busytone.$NETWORK"}
REACH_HOST=${REACH_HOST:-"reach.$NETWORK"}
NODE=${NODE:-"busytone@$NAME"}
TESTS=${TESTS:-"tests"}
FILES=${FILES:-"$(pwd)/files"}

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
	-v $TESTS:/home/user/busytone/src/custom \
	-v $FILES:/home/user/busytone/files \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env NODE=$NODE \
	--env AGENTS_NODE=$AGENTS_NODE \
	--env REACH_HOST=$REACH_HOST \
	$NETWORK/busytone
