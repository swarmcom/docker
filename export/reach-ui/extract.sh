#!/bin/sh -e
CONTAINER=${1:-"reach-ui.ezuce"}
rm -rf reach-ui
docker cp $CONTAINER:/home/user/reach-ui/dist ./reach-ui
cd reach-ui && tar cf ../reach-ui.tar ./ --owner=1000 --group=1000 && cd ../
rm -rf reach-ui
