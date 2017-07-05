#!/bin/bash
INSTALLED=`docker version --format '{{.Server.Version}}'`
REQUIRED="1.9.0"
if [ "$(printf "$REQUIRED\n$INSTALLED" | sort -V | head -n1)" == "$INSTALLED" ] && [ "$INSTALLED" != "$REQUIRED" ]
then
	echo Docker version $INSTALLED is probably too old, required version is $REQUIRED
	exit
fi
# This is the default network segment
# docker network create ezuce
# cd postgres-sipxconfig && ./build.sh
#cd ../sipxconfig && ./build.sh

#We will build and publish siplibs first due to high disk usage demanded by our build that's breaking travis-ci
cd siplibs && ./build.sh

#cd ../sipxproxy && ./build.sh
#cd ../sipxregistrar && ./build.sh


#Will then need to modify both travis.yml and this file to build and publish proxy and registrar
