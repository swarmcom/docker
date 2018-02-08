#!/bin/sh
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
PASSWORD=${PASSWORD:-"reachpass"}
NAME=${NAME:-"timescale.$NETWORK"}

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
	$NETWORK/timescale

docker exec $NAME /wait-for.sh "CREATE USER reach WITH PASSWORD '$PASSWORD'"
docker exec $NAME /wait-for.sh "CREATE DATABASE reach OWNER reach"
docker exec $NAME /wait-for.sh "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE" reach
