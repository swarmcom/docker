#!/bin/bash -e
HUB=$1
if [ -z $HUB ]
then
	echo Usage: $0 hub
	exit
fi
for IMAGE in freeswitch reach rr timescale reach-ui kamailio rrvol
do
	docker push $HUB/$IMAGE
done
exit
