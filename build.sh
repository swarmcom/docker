#!/bin/bash
INSTALLED=`docker version --format '{{.Server.Version}}'`
REQUIRED="1.9.0"
if [ "$(printf "$REQUIRED\n$INSTALLED" | sort -V | head -n1)" == "$INSTALLED" ] && [ "$INSTALLED" != "$REQUIRED" ]
then
	echo Docker version $INSTALLED is probably too old, required version is $REQUIRED
	exit
fi
# This is the default network segment
docker network create ezuce
cd base-os && ./build.sh
cd ../erlang && ./build.sh
cd ../mongodb && ./build.sh
cd ../elastic && ./build.sh
cd ../freeswitch && ./build.sh
cd ../agents && ./build.sh
cd ../reach && ./build.sh

