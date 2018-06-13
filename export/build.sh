#!/bin/bash -e
INSTALLED=`docker version --format '{{.Server.Version}}'`
REQUIRED="1.9.0"
if [ "$(printf "$REQUIRED\n$INSTALLED" | sort -V | head -n1)" == "$INSTALLED" ] && [ "$INSTALLED" != "$REQUIRED" ]
then
	echo Docker version $INSTALLED is probably too old, required version is $REQUIRED
	exit
fi

for FOLDER in agents reach3 rr timescale reach-ui kamailio freeswitch rrvol
do
	echo BUILD: $FOLDER
	cd $FOLDER
	[ -f ./extract.sh ] && ./extract.sh
	./build.sh
	cd ../
done
exit
