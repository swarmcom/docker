#!/bin/bash -e
for IMAGE in freeswitch agents reach rr busytone timescale reach-ui reach-ui-dev kamailio
do
	docker push reach3/$IMAGE
done
exit
