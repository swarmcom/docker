#!/bin/sh -e
HUB=${HUB:-"reachme3"}
docker build $BUILD_FLAGS -t $HUB/reach -t $HUB/reach:3.1.0 .
