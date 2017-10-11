#!/bin/sh -e
FLAGS=${FLAGS:-"-d"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"uniteme-centos6.$NETWORK"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

docker volume create --name etcSipxpbx
docker volume create --name varLog
docker volume create --name usrShareSipxecs
docker volume create --name usrShareWww
docker volume create --name varSipxdata

echo -n "starting: $NAME "
docker run $FLAGS \
	--net $NETWORK \
	--cap-add SYS_ADMIN \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	-v varSipxdata:/var/sipxdata \
	-v etcSipxpbx:/etc/sipxpbx \
	-v varLog:/var/log \
	-v usrShareSipxecs:/usr/share/sipxecs \
	-v usrShareWww:/usr/share/www \
	$NETWORK/uniteme-centos6
