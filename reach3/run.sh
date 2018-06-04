#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"reach.$NETWORK"}
NODE=${NODE:-"reach@$NAME"}
CFG_DB=${CFG_DB:-"`pwd`/db"}

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

# file must exists
mkdir -p $CFG_DB
touch $CFG_DB/reach_db.json
chmod o+w $CFG_DB/reach_db.json

echo -n "starting: $NAME "
docker run $FLAGS \
	-v $CFG_DB:/home/user/reach/db \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env NODE=$NODE \
	$NETWORK/reach
