#!/bin/sh -e
FLAGS=${1:-"-td"}
IMAGE=${2:-"ezuce/freeswitch-ingress"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"ingress.$NETWORK"}
EXT_IP=${EXT_IP:-"$(curl -s ifconfig.co)"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
   echo -n "stopping: "
   docker stop -t 1 $NAME
   echo -n "removing: "
   docker rm -f $NAME
fi

echo -n "starting: $NAME EXT_IP:$EXT_IP "
docker run $FLAGS \
	--net $NETWORK \
	-p 5060:5060/udp \
	-h $NAME \
	--name $NAME \
	-e EXT_IP=$EXT_IP \
	$IMAGE
