#!/bin/sh -e
NETWORK=${NETWORK:-"ezuce"}
FLAGS=${FLAGS:-"-td"}
NAME=${NAME:-"dnsfwd.$NETWORK"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker run $FLAGS \
	--restart=always \
	--net $NETWORK \
	--cap-add=NET_ADMIN \
	--dns 8.8.8.8 \
	-p 53:53/udp \
	-h $NAME \
	--name $NAME \
	ezuce/dnsfwd
