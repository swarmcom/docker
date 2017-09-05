#!/bin/sh -e
NETWORK=${1:-"ezuce"}
for CONTAINER in mongodb freeswitch elastic reach kibana agents busytone reach-ui rr
do
	if [ "$(docker inspect -f {{.State.Running}} $CONTAINER.$NETWORK)" = "true" ]
	then
		echo `bin/get-ip $CONTAINER.$NETWORK` $CONTAINER.$NETWORK
	fi
done
exit
