#!/bin/bash -e
for IMAGE in freeswitch agents reach rr timescale reach-ui kamailio rrvol
do
	docker push reach3/$IMAGE
done
exit
