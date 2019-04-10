#!/bin/sh -e
HUB=${HUB:-"reachme3"}
docker build $BUILD_FLAGS -t $HUB/freeswitch -t $HUB/freeswitch:3.2.0 .
