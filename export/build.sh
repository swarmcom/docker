#!/bin/bash -e
INSTALLED=`docker version --format '{{.Server.Version}}'`
REQUIRED="1.9.0"
if [ "$(printf "$REQUIRED\n$INSTALLED" | sort -V | head -n1)" == "$INSTALLED" ] && [ "$INSTALLED" != "$REQUIRED" ]
then
	echo Docker version $INSTALLED is probably too old, required version is $REQUIRED
	exit
fi

for FOLDER in freeswitch agents reach3 rr busytone timescale reach-ui reach-ui-dev kamailio
do
	cd $FOLDER
	[ -f ./extract.sh ] && ./extract.sh
	./build.sh
	cd ../
done
exit
