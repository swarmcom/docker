#!/bin/bash
NETWORK=${1:-"ezuce"}
export NETWORK
echo -n "starting network: $NETWORK "
docker network create $NETWORK
cd ../mongodb && ./run.sh
cd ../elastic && ./run.sh
cd ../freeswitch && ./run.sh
cd ../agents && ./run.sh
cd ../reach && ./run.sh

echo Add these to your /etc/hosts
./hosts.sh
