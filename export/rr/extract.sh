#!/bin/sh -e
CONTAINER=${1:-"rr.ezuce"}
rm -rf rr
rm -rf rr.tar
mkdir rr
docker cp build/find-debian-deps.sh $CONTAINER:/root
docker exec -it $CONTAINER /bin/bash -ic "cd rr && rm -rf _build/prod && make release"
docker exec --user root $CONTAINER /root/find-debian-deps.sh /home/user/rr/_build/prod/rel/rr | sed -e 's/\x0D//' > etc/deps
docker exec --user root $CONTAINER rm -f /root/find-debian-deps.sh
docker cp -L $CONTAINER:/home/user/rr/_build/prod/rel/rr rr
cd rr && tar cf ../rr.tar . --owner=1000 --group=1000
cd ../ && rm -rf rr
