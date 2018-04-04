#!/bin/sh -e
FLAGS=${FLAGS:-"-t"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"nginx.$NETWORK"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker create $FLAGS \
	-p 80:80 \
	-p 443:443 \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	-v /home/ezuce/keys-challenge:/challenge \
	-v /home/ezuce/keys:/keys \
	$NETWORK/nginx-ingress

docker network connect $NETWORK $NAME
docker network connect master $NAME
docker network connect devel $NAME
docker start $NAME
