#!/bin/sh -e
TOKEN=$1
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"ci.$NETWORK"}
NODE=${NODE:-"ci@$NAME"}

if [ -z $TOKEN ]
then
	echo Please provide a token to access private repo
	exit 1
fi

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker run \
	--net $NETWORK \
	--restart=always \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env TOKEN=$TOKEN \
	--env NODE=$NODE \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-td ezuce/ci
