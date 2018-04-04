#!/bin/sh
for FOLDER in freeswitch-reach3 freeswitch-agents timescale reach3 rr reach-ui busytone kamailio
do
	cd $FOLDER && ./run.sh && cd ../
done
exit

