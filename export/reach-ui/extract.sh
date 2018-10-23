#!/bin/sh -e
NETWORK=${NETWORK:-"master"}
CONTAINER=${1:-"reach-ui.$NETWORK"}
rm -rf reach-ui
rm -rf reach-ui.tar
mkdir reach-ui
docker cp $CONTAINER:/home/user/reach-ui/index.html ./reach-ui/index.html
docker cp $CONTAINER:/home/user/reach-ui/dist ./reach-ui/dist
cd reach-ui && tar cf ../reach-ui.tar ./ --owner=1000 --group=1000 && cd ../
rm -rf reach-ui
