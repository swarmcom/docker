#!/bin/sh -e
NETWORK=${1:-"ezuce"}
export NETWORK
echo -n "starting network: $NETWORK "
docker network create $NETWORK
