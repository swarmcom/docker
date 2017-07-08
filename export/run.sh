#!/bin/bash
NETWORK=${1:-"ezuce"}
export NETWORK
echo -n "starting network: $NETWORK "
docker network create $NETWORK
cd ./freeswitch && ./run.sh
cd ./agents && ./run.sh
