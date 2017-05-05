#!/bin/sh -e
NAME=ezuce-ci
TOKEN=$1

if [ -z $TOKEN ]
then
	echo Please provide a token to access private repo: $0 token
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
	-h $NAME \
	--name $NAME \
	-e TOKEN=$TOKEN \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-td ezuce/ci
