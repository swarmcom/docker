#!/bin/sh -e
NETWORK=${1:-"ezuce"}
for CONTAINER in mongodb sipxcom redis freeswitch elastic reach agents kibana
do
	if [ "$(docker inspect -f {{.State.Running}} $CONTAINER.$NETWORK)" = "true" ]
	then
		echo `bin/get-ip $CONTAINER.$NETWORK` $CONTAINER.$NETWORK
	fi
done
exit
