#!/bin/bash
NETWORK=${1:-"ezuce"}
export NETWORK
echo -n "starting network: $NETWORK "
docker network create $NETWORK
cd ./mongodb && ./run.sh
cd ../elastic && ./run.sh
cd ../kibana && ./run.sh
cd ../freeswitch-1708 && ./run.sh
cd ../rr && ./run.sh
cd ../busytone && ./run.sh
cd ../freeswitch-agents && ./run.sh
echo Wait for Elastic to start as we need it running before Reach
sleep 5
cd ../reach && ./run.sh

echo Add these to your /etc/hosts
cd ../ && ./hosts.sh
