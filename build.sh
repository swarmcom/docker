#!/bin/sh
for FOLDER in base-os erlang freeswitch-reach3 freeswitch-agents timescale rr kamailio reach3 reach-ui busytone
do
	cd $FOLDER && ./build.sh && cd ../
done
exit

