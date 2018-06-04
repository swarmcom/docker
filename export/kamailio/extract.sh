#!/bin/sh -e
NETWORK=${NETWORK:-"master"}
CONTAINER=${1:-"kamailio.$NETWORK"}
rm -rf kamailio
rm -rf kamailio.tar
mkdir -p kamailio
docker cp build/find-debian-deps.sh $CONTAINER:/root
docker exec --user root $CONTAINER /root/find-debian-deps.sh /home/user/kamailio | sed -e 's/\x0D//' > etc/deps
docker exec --user root $CONTAINER rm -f /root/find-debian-deps.sh
docker cp $CONTAINER:/home/user/kamailio kamailio/
docker cp $CONTAINER:/home/user/etc kamailio/
cd kamailio && tar cf ../kamailio.tar ./ --owner=1000 --group=1000 && cd ../
rm -rf kamailio
