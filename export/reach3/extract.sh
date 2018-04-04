#!/bin/sh -e
CONTAINER=${1:-"reach.ezuce"}
rm -rf reach3
rm -rf reach3.tar
mkdir reach3
docker cp build/find-debian-deps.sh $CONTAINER:/root
docker exec -it $CONTAINER /bin/bash -ic "cd reach && rm -rf _build/prod && make release"
docker exec --user root $CONTAINER /root/find-debian-deps.sh /home/user/reach/_build/prod/rel/reach | sed -e 's/\x0D//' > etc/deps
docker exec --user root $CONTAINER rm -f /root/find-debian-deps.sh
docker cp -L $CONTAINER:/home/user/reach/_build/prod/rel/reach reach3
cd reach3
find ./ -name src -type d | xargs rm -r
tar cf ../reach3.tar . --owner=1000 --group=1000
cd ../ && rm -rf reach3
