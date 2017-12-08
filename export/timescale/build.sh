#!/bin/sh -e
NETWORK=${NETWORK:-"reach3"}
docker build $BUILD_FLAGS -t $NETWORK/timescale .
