#!/bin/sh -e
NETWORK=${1:-"ezuce"}
for CONTAINER in reach busytone reach-ui rr nginx ci timescale grafana kamailio freeswitch agents
do
	if [ "$(docker inspect -f {{.State.Running}} $CONTAINER.$NETWORK)" = "true" ]
	then
		echo `bin/get-ip $CONTAINER.$NETWORK` $CONTAINER.$NETWORK
	fi
done
exit
