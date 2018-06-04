#!/bin/sh -e
NETWORK=${NETWORK:-"master"}
CONTAINER=${1:-"busytone.$NETWORK"}
rm -rf busytone
rm -rf busytone.tar
mkdir busytone
docker cp build/find-debian-deps.sh $CONTAINER:/root
docker exec -it $CONTAINER /bin/bash -ic "cd busytone && rm -rf _build/prod && make release"
docker exec --user root $CONTAINER /root/find-debian-deps.sh /home/user/busytone/_build/prod/rel/busytone | sed -e 's/\x0D//' > etc/deps
docker exec --user root $CONTAINER rm -f /root/find-debian-deps.sh
docker cp -L $CONTAINER:/home/user/busytone/_build/prod/rel/busytone busytone
cd busytone && tar cf ../busytone.tar . --owner=1000 --group=1000
cd ../ && rm -rf busytone
