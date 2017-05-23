#!/bin/sh -e
#NETWORK=${NETWORK:-"ezuce"}
docker build $BUILD_FLAGS --build-arg -t ezuce/redis .
