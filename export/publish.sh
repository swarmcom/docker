#!/bin/bash -e
for IMAGE in freeswitch agents reach rr timescale reach-ui kamailio
do
	docker push reach3/$IMAGE
done
exit
