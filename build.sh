#!/bin/sh
for FOLDER in base-os erlang freeswitch-reach3 freeswitch-agents timescale reach3 rr reach-ui busytone freeswitch-agents
do
	cd $FOLDER && ./build.sh && cd ../
done
exit

