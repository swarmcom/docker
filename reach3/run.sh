#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"reach.$NETWORK"}
FSNODE=${FSNODE:-"freeswitch@freeswitch.$NETWORK"}
KAMNODE=${KAMNODE:-"kamailio@kamailio.$NETWORK"}
NODE=${NODE:-"reach@$NAME"}
CFG_DB=${CFG_DB:-"`pwd`/reach_db.json"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	STAMP=`date +%Y-%m-%d-%H-%M-%S`
	mkdir -p logs
	docker logs $NAME > logs/$STAMP

	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker run $FLAGS \
	-v $CFG_DB:/home/user/reach/files/reach_db.json \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env NODE=$NODE \
	--env FSNODE=$FSNODE \
	--env KAMNODE=$KAMNODE \
	$NETWORK/reach
