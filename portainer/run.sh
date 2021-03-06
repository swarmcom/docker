#!/bin/sh -e
FLAGS=${FLAGS:-"-d"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"portainer.$NETWORK"}

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
	-p 9000:9000 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /opt/portainer:/data \
	$NETWORK/portainer
