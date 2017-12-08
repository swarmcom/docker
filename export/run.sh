#!/bin/bash -e
INSTALLED=`docker version --format '{{.Server.Version}}'`
REQUIRED="1.9.0"
if [ "$(printf "$REQUIRED\n$INSTALLED" | sort -V | head -n1)" == "$INSTALLED" ] && [ "$INSTALLED" != "$REQUIRED" ]
then
	echo Docker version $INSTALLED is probably too old, required version is $REQUIRED
	exit
fi

NETWORK=${1:-"reach3"}
export NETWORK
echo -n "starting network: $NETWORK "
docker network create $NETWORK

for FOLDER in freeswitch agents reach3 rr busytone timescale reach-ui reach-ui-dev kamailio
do
	cd $FOLDER
	./run.sh
	cd ../
done
exit
